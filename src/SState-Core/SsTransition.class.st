Class {
	#name : 'SsTransition',
	#superclass : 'SsObject',
	#instVars : [
		'nextStateId',
		'guardCondition',
		'action'
	],
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'instance creation' }
SsTransition class >> action: aBlockOrMessageSend to: nextStateId [
	| inst |
	inst := self nextStateId: nextStateId.
	inst action: aBlockOrMessageSend.
	^inst
]

{ #category : 'instance creation' }
SsTransition class >> guarded: guardCondition action: aBlockOrMessageSend to: nextStateId [
	| inst |
	inst := self nextStateId: nextStateId.
	inst guardCondition: guardCondition.
	inst action: aBlockOrMessageSend.
	^inst
]

{ #category : 'instance creation' }
SsTransition class >> nextStateId: aStateSymbol [
	^self new nextStateId: aStateSymbol
]

{ #category : 'accessing' }
SsTransition >> action [
	^ action
]

{ #category : 'accessing' }
SsTransition >> action: aBlockOrMessageSend [
	action := aBlockOrMessageSend
]

{ #category : 'actions' }
SsTransition >> activate [
	self perform. 	"or send event"
	self changeState.
	
	
]

{ #category : 'actions' }
SsTransition >> changeState [
	self changeStateTo: self nextStateId.
]

{ #category : 'private' }
SsTransition >> changeStateTo: aStateSymbol [

	self stateMachine changeStateTo: aStateSymbol on: self currentEvent
	
]

{ #category : 'actions' }
SsTransition >> checkGuard [
	self guardCondition ifNil: [ ^true ].
	
	^self guardCondition cull: self context	cull: self currentEvent
	
]

{ #category : 'accessing' }
SsTransition >> guardCondition [
	^ guardCondition
]

{ #category : 'accessing' }
SsTransition >> guardCondition: anObject [
	guardCondition := anObject
]

{ #category : 'accessing' }
SsTransition >> nextState [
	^self stateMachine stateAt: self nextStateId.
	
]

{ #category : 'accessing' }
SsTransition >> nextStateId [
	^nextStateId
]

{ #category : 'accessing' }
SsTransition >> nextStateId: anObject [
	nextStateId := anObject
]

{ #category : 'actions' }
SsTransition >> perform [
	^ self action ifNotNil: [:act | act cull: self context cull: self currentEvent] 

]
