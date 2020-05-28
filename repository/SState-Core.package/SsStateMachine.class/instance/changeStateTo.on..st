changing state
changeStateTo: aStateSymbol on: anEvent
	| state |
	state := self stateAt: aStateSymbol.
	state currentEvent: anEvent.
	self updateCurrentState: state.