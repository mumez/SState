"
I am the abstract base for all state machine building blocks (states, transitions) that carry an identity and belong to a state machine.

Responsibility:
- I hold a unique identifier (auto-generated UUID if not set) used as a dictionary key within a state machine
- I keep a reference to my owning SsStateMachine and to the event currently being processed
- I provide identity-based equality (#=, #hash) and convenience access to shared context/debug logging

Collaborators:
- SsStateMachine: I hold a reference to my owning state machine and delegate #context and debug logging to it
- SsDebugLogger: I delegate #debug: to the shared default logger instance

Public API and Key Messages:
- #id - unique identifier, lazily generated as a UUID string if never set
- #stateMachine / #stateMachine: - accessor to the owning state machine
- #context - convenience accessor to my state machine's shared context (nil-safe)

Implementation Points:
- Equality is based on class + id, not object identity, so two instances with the same id are considered equal
"
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
