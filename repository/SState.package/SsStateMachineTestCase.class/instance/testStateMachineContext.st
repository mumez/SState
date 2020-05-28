testing
testStateMachineContext
	| stateMachine stateA stateB stateC |
	stateMachine := SsStateMachine new.
	self initCounter.
	
	stateA := (stateMachine addStateNamed: #stateA)
		entryAction:[:ctx | ctx at: #stateAEntry put: (self incrementCounter, 'sN')];
		activity:[:ctx | ctx at: #stateAActivity put: (self incrementCounter, 'sV')];
		exitAction:[:ctx | ctx at: #stateAExit put: (self incrementCounter, 'sX')];
		when: #toB to: #stateB;
		when: #toC to: #stateC.
		
	stateB := (stateMachine addStateNamed: #stateB)
		when: #toA to: #stateA.
		
	stateC := (stateMachine addStateNamed: #stateC)
		when: #toA do: [:ctx | ctx at: #transCA put: (self incrementCounter, 'tCA')] to: #stateA;
		endWhen: #end.
		
	stateMachine setStartStateTo: #stateA.
	self assert:(stateMachine currentState id = #stateA).
	self assert:(stateMachine context includesKey: #stateAEntry).
	self assert: ((stateMachine context at: #stateAEntry) = '1sN').
	self assert:(stateMachine context includesKey: #stateAActivity).
	self assert: ((stateMachine context at: #stateAActivity) = '2sV').
	self deny:(stateMachine context includesKey: #stateAExit).

	stateMachine handleEvent: #toB.
	self assert:(stateMachine currentState id = #stateB). 
	self assert:(stateMachine context includesKey: #stateAExit).
	self assert: ((stateMachine context at: #stateAExit) = '3sX').
	
	stateMachine handleEvent: #toB.
	self assert:(stateMachine currentState id = #stateB).
	
	self should: [stateMachine handleEvent: #toC] raise: SsEventNotSupposed.
	self assert:(stateMachine currentState id = #stateB).
	
	stateMachine handleEvent: #toA.
	self assert:(stateMachine currentState id = #stateA).
	self assert: ((stateMachine context at: #stateAEntry) = '4sN').
	self assert: ((stateMachine context at: #stateAActivity) = '5sV').
	
	stateMachine handleEvent: #toC.
	self assert: ((stateMachine context at: #stateAExit) = '6sX').
	self assert:(stateMachine currentState id = #stateC).
	self deny:(stateMachine context includesKey: #transCA).
	
	stateMachine handleEvent: #toA.
	self assert:(stateMachine currentState id = #stateA).
	self assert:(stateMachine context includesKey: #transCA).
	self assert: ((stateMachine context at: #transCA) = '7tCA').
	
	stateMachine handleEvent: #toC; handleEvent: #end.
	
	self assert:(stateMachine currentState id = #endState).
	self assert: ((stateMachine context at: #stateAEntry) = '8sN').
	self assert: ((stateMachine context at: #stateAActivity) = '9sV').
	self assert: ((stateMachine context at: #stateAExit) = '10sX').