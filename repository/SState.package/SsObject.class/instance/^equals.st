comparing
= other
	self class = other class ifFalse: [^false].
	^self id = other id