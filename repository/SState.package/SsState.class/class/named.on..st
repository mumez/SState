instance creation
named: stateName on: stateMachine
	| inst |
	inst := self named: stateName.
	stateMachine addState: inst.
	^inst