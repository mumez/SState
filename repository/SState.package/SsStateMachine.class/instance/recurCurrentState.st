accessing
recurCurrentState
	| state |
	state := self currentState.
	state isNil
		ifTrue: [^ self].
	[state hasSubStates]
		whileTrue: [state := state currentSubState].
	^ state