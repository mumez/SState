"
I represent a transition between two states in a state machine, optionally guarded by a condition and carrying an action to perform.

Responsibility:
- I know which state to move to next (nextStateId)
- I optionally hold a guard condition that must evaluate true before I can fire
- I optionally hold an action (block or message send) to execute when I activate

Collaborators:
- SsStateMachine: I ask it to change the current state to my nextStateId when I activate
- SsState: states own me and activate me in response to matching events
- SsDecision: subclass that picks nextStateId dynamically based on the evaluated action result

Public API and Key Messages:
- #activate - performs my action then changes the state machine's current state to nextStateId
- #checkGuard - evaluates guardCondition (with context/event) to decide whether I may fire; true if no guard is set
- #guarded:action:to: / #action:to: - instance-creation helpers for building a transition with or without a guard

Implementation Points:
- #action and #guardCondition are cull:cull: evaluated, so they may take 0, 1 (context) or 2 (context, event) arguments
"
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
