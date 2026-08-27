"
I am a simple, ""switchable"" Transcript-based logger shared as a lazily-created singleton via #default.

Responsibility:
- I print debug/info/warn/error messages to the Transcript, but only when I am active
- I hold a single default instance so state machine objects can log without needing their own reference

Collaborators:
- SsObject / SsStateMachine: call `SsDebugLogger default debug:` to log without holding their own logger reference
- Transcript: I write all messages here, each prefixed with a level tag (DEBUG>, INFO>, WARN>, ERROR>)

Public API and Key Messages:
- SsDebugLogger class >> default - the shared lazily-created instance used throughout the library
- #debug: / #info: / #warn: / #error: - print anObject's printString to the Transcript if #isActive
- #isActive / #isActive: - toggles whether messages are actually printed; defaults to false (silent)

Implementation Points:
- Logging is off by default; call `SsDebugLogger default isActive: true` to see output
- #actualLogger is currently unused by the logging methods themselves; it exists as an extension point for redirecting output
"
Class {
	#name : 'SsDebugLogger',
	#superclass : 'Object',
	#instVars : [
		'actualLogger',
		'isActive'
	],
	#classInstVars : [
		'default'
	],
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'class initialization' }
SsDebugLogger class >> default [
	^default ifNil: [default := self new]
]

{ #category : 'class initialization' }
SsDebugLogger class >> release [
	default := nil
]

{ #category : 'accessing' }
SsDebugLogger >> actualLogger [
	^ actualLogger ifNil: [actualLogger := self]
]

{ #category : 'accessing' }
SsDebugLogger >> actualLogger: anObject [
	actualLogger := anObject
]

{ #category : 'actions' }
SsDebugLogger >> debug: anObject [
	self isActive
		ifTrue: [Transcript cr; show: 'DEBUG> '.
			Transcript show: anObject printString]
]

{ #category : 'actions' }
SsDebugLogger >> error: anObject [
	self isActive
		ifTrue: [Transcript cr; show: 'ERROR> '.
			Transcript show: anObject printString]
]

{ #category : 'actions' }
SsDebugLogger >> info: anObject [
	self isActive
		ifTrue: [Transcript cr; show: 'INFO> '.
			Transcript show: anObject printString]
]

{ #category : 'testing' }
SsDebugLogger >> isActive [
	^isActive ifNil: [isActive := false]
]

{ #category : 'accessing' }
SsDebugLogger >> isActive: aBoolean [
	isActive := aBoolean
]

{ #category : 'actions' }
SsDebugLogger >> warn: anObject [
	self isActive
		ifTrue: [Transcript cr; show: 'WARN> '.
			Transcript show: anObject printString]
]
