actions
info: anObject
	self isActive
		ifTrue: [Transcript cr; show: 'INFO> '.
			Transcript show: anObject printString]