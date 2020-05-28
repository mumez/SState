testing
testEventWithArguments
	| stateMachine toA toB toC stateA stateB stateC |
	stateMachine := SsStateMachine new.
	self initCounter.
	
	toA := SsEvent type: #toA arguments: #(#toAArg).
	toB := SsEvent type: #toB arguments: #(#toBArg).
	toC := SsEvent type: #toC arguments: #(#toCArg).
	
	stateA := (stateMachine addStateNamed: #stateA)
		entryAction:[:ctx :ev | ctx at: #stateAEntry put: ev];
		activity:[:ctx :ev | ctx at: #stateAActivity put: ev];
		exitAction:[:ctx :ev | ctx at: #stateAExit put: ev];
		when: toB to: #stateB;
		when: toC to: #stateC.
		
	stateB := (stateMachine addStateNamed: #stateB)
		when: toA to: #stateA.
		
	stateC := (stateMachine addStateNamed: #stateC)
		when: #toA do: [:ctx :ev | ctx at: #transCA put: ev] to: #stateA;
		endWhen: #end.
		
	stateMachine setStartStateTo: #stateA.
	self assert:(stateMachine currentState id = #stateA).
	self assert:(stateMachine context includesKey: #stateAEntry).
	self assert: ((stateMachine context at: #stateAEntry) isNil).
	self assert:(stateMachine context includesKey: #stateAActivity).
	self assert: ((stateMachine context at: #stateAActivity) isNil).
	self deny:(stateMachine context includesKey: #stateAExit).

	stateMachine handleEvent: toB.
	self assert:(stateMachine currentState id = #stateB). 
	self assert:(stateMachine context includesKey: #stateAExit).
	self assert: ((stateMachine context at: #stateAExit) arguments = #(#toBArg)).
	
	stateMachine handleEvent: toB.
	self assert:(stateMachine currentState id = #stateB).
	
	self should: [stateMachine handleEvent: #toC] raise: SsEventNotSupposed.
	self assert:(stateMachine currentState id = #stateB).
	
	stateMachine handleEvent: toA.
	self assert:(stateMachine currentState id = #stateA).
	self assert: ((stateMachine context at: #stateAEntry) arguments = #(#toAArg)).
	self assert: ((stateMachine context at: #stateAActivity) arguments = #(#toAArg)).
	
	stateMachine handleEvent: toC.
	self assert: ((stateMachine context at: #stateAExit) arguments = #(#toCArg)).
	self assert:(stateMachine currentState id = #stateC).
	self deny:(stateMachine context includesKey: #transCA).
	
	stateMachine handleEvent: toA.
	self assert:(stateMachine currentState id = #stateA).
	self assert:(stateMachine context includesKey: #transCA).
	self assert: ((stateMachine context at: #transCA) arguments = #(#toAArg)).
	
	stateMachine handleEvent: toC; handleEvent: #end.
	
	self assert:(stateMachine currentState id = #endState).
	self assert: ((stateMachine currentState currentEvent) isNil).
	