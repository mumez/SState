actions
setStartStateTo: aStateSymbol
	self startState: (self stateAt: aStateSymbol).
	self changeStateTo: aStateSymbol