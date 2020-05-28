actions
checkGuard
	self guardCondition ifNil: [ ^true ].
	
	^self guardCondition cull: self context	cull: self currentEvent
	