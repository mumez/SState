Class {
	#name : 'SsObject',
	#superclass : 'Object',
	#instVars : [
		'id',
		'stateMachine',
		'currentEvent'
	],
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'instance creation' }
SsObject class >> id: anId [
	^self new id: anId
]

{ #category : 'comparing' }
SsObject >> = other [
	self class = other class ifFalse: [^false].
	^self id = other id
]

{ #category : 'actions-event' }
SsObject >> context [
	^self stateMachine ifNotNil:[:sc | sc context]
]

{ #category : 'accessing' }
SsObject >> currentEvent [
	^ currentEvent
]

{ #category : 'accessing' }
SsObject >> currentEvent: anObject [
	currentEvent := anObject
]

{ #category : 'debugging' }
SsObject >> debug: anObject [ 
	SsDebugLogger default debug: anObject
]

{ #category : 'comparing' }
SsObject >> hash [
	^self id hash
]

{ #category : 'accessing' }
SsObject >> id [
	^ id ifNil: [id := UUID new asString36]
]

{ #category : 'accessing' }
SsObject >> id: anObject [
	id := anObject
]

{ #category : 'initialize-release' }
SsObject >> initialize [
	super initialize
]

{ #category : 'printing' }
SsObject >> printOn: aStream [
	aStream nextPutAll: self className.
	aStream nextPutAll: ' (', self id , ')'
]

{ #category : 'accessing' }
SsObject >> stateMachine [
	^stateMachine
]

{ #category : 'accessing' }
SsObject >> stateMachine: aStateMachine [
	stateMachine := aStateMachine
]
