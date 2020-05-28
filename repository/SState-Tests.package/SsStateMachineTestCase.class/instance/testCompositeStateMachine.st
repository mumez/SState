testing
testCompositeStateMachine
	| stateMachine subStateMachine |
	stateMachine := SsTestCompositeStateMachine new.
	self initCounter.
		
	self assert:(stateMachine currentState id = #state1).
	stateMachine handleEvent: #event12.
	
	self assert:(stateMachine currentState id = #state2).
	stateMachine handleEvent: #event12.
	subStateMachine := stateMachine currentState subStateMachine.
	
	self assert:(stateMachine currentState id = #state2).
	self assert:(stateMachine recurCurrentState id = #state2).
	
	stateMachine handleEvent: #event21.
	self assert:(stateMachine currentState id = #state1).
	self assert:(stateMachine recurCurrentState id = #state1).
	
	stateMachine handleEvent: #event12.
	self assert:(stateMachine currentState id = #state2).
	self assert:(stateMachine recurCurrentState id = #state1).
	
	self assert: (stateMachine changes asArray = #('s1->s2' 's2->s1' 's1->s2')).
	self assert: (subStateMachine changes asArray = #('ss1->ss2')).
	