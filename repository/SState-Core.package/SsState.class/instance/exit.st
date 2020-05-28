state-actions
exit
	self debug: '#exit'.
	self exitAction ifNotNil: [:act | act cull: self context cull: self currentEvent].
	self subStateMachine notNil
		ifTrue: [self subStateMachine currentState exit.
				self subStateMachine reset]