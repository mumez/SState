private
changeStateTo: aStateSymbol

	self stateMachine changeStateTo: aStateSymbol on: self currentEvent
	