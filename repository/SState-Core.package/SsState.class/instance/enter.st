state-actions
enter
	self debug: '#enter'.
	self entryAction ifNotNil: [:act | act cull: self context cull: self currentEvent].
	self subStateMachine notNil
		ifTrue: [self subStateMachine start]