printing
printOn: aStream
	aStream nextPutAll: 'Event: '.
	aStream space.
	aStream nextPutAll: self type asString.
	aStream space.
	aStream nextPutAll: self arguments printString.