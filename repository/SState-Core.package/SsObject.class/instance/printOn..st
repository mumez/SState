printing
printOn: aStream
	aStream nextPutAll: self className.
	aStream nextPutAll: ' (', self id , ')'