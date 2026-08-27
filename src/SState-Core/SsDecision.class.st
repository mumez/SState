"
I am a transition that branches to one of two next states based on the boolean result of my action.

Responsibility:
- I evaluate my inherited action (a block or message send) and pick trueStateId or falseStateId as my nextStateId accordingly

Collaborators:
- SsTransition: my superclass; I reuse #activate and #checkGuard, overriding only #perform to add the branching logic
- SsStateMachine: created via #setDecisionFrom:if:trueTo:falseTo: to wire a conditional automatic transition

Public API and Key Messages:
- SsDecision class >> if:trueTo:falseTo: - creates a decision with the condition block and both branch state ids
- #trueStateId / #falseStateId - accessors for the two possible destinations

Implementation Points:
- #perform must be evaluated before #nextStateId is meaningful, since it is set as a side effect of evaluating the action
"
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
