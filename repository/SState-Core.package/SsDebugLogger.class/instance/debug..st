actions
debug: anObject
	self isActive
		ifTrue: [Transcript cr; show: 'DEBUG> '.
			Transcript show: anObject printString]