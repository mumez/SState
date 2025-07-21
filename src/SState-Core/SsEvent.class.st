Class {
	#name : 'SsEvent',
	#superclass : 'Object',
	#instVars : [
		'handled',
		'arguments',
		'type'
	],
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'instance creation' }
SsEvent class >> type: aSymbol [
	^self type: aSymbol arguments: nil
]

{ #category : 'instance creation' }
SsEvent class >> type: aSymbol arguments: args [
	^self new type: aSymbol; arguments: args; yourself
]

{ #category : 'accessing' }
SsEvent >> arguments [
	arguments isNil ifTrue:[arguments := Array new].
	^arguments
]

{ #category : 'accessing' }
SsEvent >> arguments: anArray [
	arguments := anArray
]

{ #category : 'accessing' }
SsEvent >> handled [
	handled isNil ifTrue:[handled := false].
	^handled
]

{ #category : 'accessing' }
SsEvent >> handled: aBoolean [
	handled := aBoolean
]

{ #category : 'printing' }
SsEvent >> printOn: aStream [
	aStream nextPutAll: 'Event: '.
	aStream space.
	aStream nextPutAll: self type asString.
	aStream space.
	aStream nextPutAll: self arguments printString.
]

{ #category : 'accessing' }
SsEvent >> type [
	^type
]

{ #category : 'accessing' }
SsEvent >> type: aSymbol [
	type := aSymbol
]
