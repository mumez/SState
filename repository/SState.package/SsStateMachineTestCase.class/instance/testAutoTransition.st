testing
testAutoTransition
	| stateMachine stateA stateB stateC |
	stateMachine := SsStateMachine new.
	self initCounter.
	
	stateA := (stateMachine addStateNamed: #stateA)
		when: #toB to: #stateB.
		
	stateB := (stateMachine addStateNamed: #stateB).
	stateB activity: [self incrementCounter].
		
	stateC := (stateMachine addStateNamed: #stateC).
	stateC entryAction: [self incrementCounter].
	
	stateMachine setAutoFrom: #stateB to: #stateC.
	stateMachine setStartStateTo: #stateA.
	
	self assert:(stateMachine currentState id = #stateA).
	stateMachine handleEvent: #toB.
	self assert:(stateMachine currentState id = #stateC).
	self assert: counter = 2