actions-events-basic
when: anEventOrSymbol doTransition: aTransition 
	| eventType |
	eventType := anEventOrSymbol isString ifTrue: [anEventOrSymbol] ifFalse: [anEventOrSymbol type].
	self when: eventType fire: aTransition id.
	self stateMachine addTransition: aTransition.