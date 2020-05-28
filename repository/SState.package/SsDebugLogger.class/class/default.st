class initialization
default 
	default isNil ifTrue: [default := self new].
	^default