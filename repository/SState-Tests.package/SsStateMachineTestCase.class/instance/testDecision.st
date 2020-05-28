testing
testDecision
	| stateMachine steps testNum stateA stateB even odd |
	stateMachine := SsStateMachine new.
	steps := OrderedCollection new.
	testNum := 0.
	
	stateA := (stateMachine addStateNamed: #stateA)
		when: #toB to: #stateB.
		
	stateB := (stateMachine addStateNamed: #stateB).
	stateB entryAction: [steps add: #b].
		
	even := (stateMachine addStateNamed: #even).
	even entryAction: [steps add: #c].
	even when: #toA to: #stateA.
	
	odd := (stateMachine addStateNamed: #odd).
	odd entryAction: [steps add: #d].
	odd when: #toA to: #stateA.
	
	stateMachine setDecisionFrom: #stateB if: [testNum even] trueTo: #even falseTo: #odd.
	stateMachine setStartStateTo: #stateA.
	
	self assert:(stateMachine currentState id = #stateA).
	stateMachine handleEvent: #toB.
	self assert:(stateMachine currentState id = #even).
	stateMachine handleEvent: #toA.
	testNum := 1.
	stateMachine handleEvent: #toB.
	self assert:(stateMachine currentState id = #odd).
	stateMachine handleEvent: #toA.
	testNum := 2.
	stateMachine handleEvent: #toB.
	self assert:(stateMachine currentState id = #even).
	self assert: steps asArray =  #(#b #c #b #d #b #c)