Class {
	#name : 'SsDecision',
	#superclass : 'SsTransition',
	#instVars : [
		'trueStateId',
		'falseStateId'
	],
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'instance creation' }
SsDecision class >> if: aBlockOrMessageSend trueTo: trueStateId falseTo: falseStateId [
	| inst |
	inst := self new.
	inst action: aBlockOrMessageSend.
	inst trueStateId: trueStateId.
	inst falseStateId: falseStateId.
	^inst
]

{ #category : 'accessing' }
SsDecision >> falseStateId [
	^ falseStateId
]

{ #category : 'accessing' }
SsDecision >> falseStateId: anObject [
	falseStateId := anObject
]

{ #category : 'actions' }
SsDecision >> perform [
	| evalResult |
	evalResult := super perform.
	self
		nextStateId: (evalResult
				ifTrue: [self trueStateId]
				ifFalse: [self falseStateId])
]

{ #category : 'accessing' }
SsDecision >> trueStateId [
	^ trueStateId
]

{ #category : 'accessing' }
SsDecision >> trueStateId: anObject [
	trueStateId := anObject
]
