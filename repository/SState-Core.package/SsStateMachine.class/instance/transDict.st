accessing
transDict
	transDict isNil ifTrue:[transDict := IdentityDictionary new].
	^transDict