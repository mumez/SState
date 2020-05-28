testing
testGuardedTransition
	| stateMachine stateA stateB stateC |
	stateMachine := SsStateMachine new.
	self initCounter.
	
	stateA := (stateMachine addStateNamed: #stateA)
		when: #toB guarded: [counter < 2] to: #stateB;
		endWhen: #exit guarded: [counter >= 3].
		
	stateB := (stateMachine addStateNamed: #stateB).
	stateB activity: [self incrementCounter].
	stateB when: #toC to: #stateC.
	stateB when: #toA to: #stateA.
		
	stateC := (stateMachine addStateNamed: #stateC).
	stateC exitAction: [self incrementCounter].
	stateC when: #toB to: #stateB.
	
	stateMachine setStartStateTo: #stateA.
	self assert:(stateMachine currentState id = #stateA).
	stateMachine handleEvent: #exit.
	self assert:(stateMachine currentState id = #stateA).
	stateMachine handleEvent: #toB.
	self assert:(stateMachine currentState id = #stateB).
	self assert: counter = 1.
	stateMachine handleEvent: #toC.
	stateMachine handleEvent: #toB.
	stateMachine handleEvent: #toA.
	self assert: counter = 3.
	self assert:(stateMachine currentState id = #stateA).
	stateMachine handleEvent: #toB.
	self assert:(stateMachine currentState id = #stateA).
	stateMachine handleEvent: #exit.
	self assert:(stateMachine currentState id = #endState).