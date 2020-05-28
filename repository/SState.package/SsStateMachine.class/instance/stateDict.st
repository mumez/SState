accessing
stateDict
	stateDict isNil ifTrue:[stateDict := IdentityDictionary new].
	^stateDict