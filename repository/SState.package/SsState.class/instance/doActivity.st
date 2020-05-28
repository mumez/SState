state-actions
doActivity
	self debug: '#doActivity'.
	self activity ifNotNil: [:act | act cull: self context cull: self currentEvent].
	self isAuto ifTrue: [self handleEvent: #'_ended'].
