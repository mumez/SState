actions
warn: anObject
	self isActive
		ifTrue: [Transcript cr; show: 'WARN> '.
			Transcript show: anObject printString]