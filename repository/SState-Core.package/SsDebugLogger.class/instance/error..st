actions
error: anObject
	self isActive
		ifTrue: [Transcript cr; show: 'ERROR> '.
			Transcript show: anObject printString]