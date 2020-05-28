event handling
basicHandleEvent: anEvent 
	| transId |
	transId := self findTransId: anEvent.
	transId isNil ifFalse: [self activateTransitionAt: transId for: anEvent].
	(anEvent handled not and: [self subStateMachine notNil]) ifTrue: [self subStateMachine handleEvent: anEvent]