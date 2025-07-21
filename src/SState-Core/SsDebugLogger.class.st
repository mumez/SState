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
	default isNil ifTrue: [default := self new].
	^default
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
	isActive isNil ifTrue: [isActive := false].
	^isActive
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
