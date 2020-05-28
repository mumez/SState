accessing-substates
hasSubStates
	^self subStateMachine notNil and:[self subStateMachine hasStates]
	