"
I am a hierarchical, event-driven state machine: I hold a set of states and transitions, track the current state, and dispatch events to it.

Responsibility:
- I own the collection of states (stateDict) and transitions (transDict), keyed by id
- I track the current state and the designated start state, and drive state entry/exit on changes
- I dispatch incoming events to the current state and notify any registered listener state machines
- I hold a shared context Dictionary that states and transitions can read and write

Collaborators:
- SsState: I look up states by id, and delegate #enter / #doActivity to the current state on every state change
- SsTransition / SsDecision: created via #setAutoFrom:to: and #setDecisionFrom:if:trueTo:falseTo: to wire automatic/conditional transitions
- SsEvent: events accepted by #handleEvent: are dispatched to the current state
- SsEndState: automatically added on #initialize and used by #atEnd to detect completion

Public API and Key Messages:
- #addState: / #addTransition: - register a state or transition, wiring it back to me
- #setStartStateTo: - designates and immediately enters the start state
- #handleEvent: / #handleEvent:ifFailed: - dispatches an event (symbol or SsEvent) to the current state, running aBlock if unhandled
- #start - resets to the start state and enters/activates it
- #atEnd - true once the current state is the shared SsEndState

Implementation Points:
- stateDict/transDict/listeners are lazily initialized IdentityDictionary/OrderedCollection instances
- Sub-state machines are supported: states can nest their own SsStateMachine (see SsState>>subStateMachine)
"
Class {
	#name : 'SsStateMachine',
	#superclass : 'Object',
	#instVars : [
		'currentState',
		'stateDict',
		'transDict',
		'listeners',
		'startState',
		'context'
	],
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'private' }
SsStateMachine >> addListener: aStatechart [ 
	self listeners add: aStatechart
]

{ #category : 'adding' }
SsStateMachine >> addState: aState [
	^self stateAt: aState id put: aState
]

{ #category : 'actions' }
SsStateMachine >> addStateNamed: stateName [
	^ self addState: (SsState named: stateName)
]

{ #category : 'adding' }
SsStateMachine >> addTransition: aTransition [
	^self transAt: aTransition id put: aTransition
]

{ #category : 'testing' }
SsStateMachine >> atEnd [
	^self currentState isKindOf: SsEndState
]

{ #category : 'private' }
SsStateMachine >> basicHandleEvent: anEvent ifFailed: aBlock [
	self listeners	do: [:each | each handleEvent: anEvent copy].
		
	self currentState handleEvent: anEvent.
	anEvent handled ifFalse: [
		aBlock cull: self
	].
	
]

{ #category : 'changing state' }
SsStateMachine >> changeStateTo: aStateSymbol [
	self changeStateTo: aStateSymbol on: nil
]

{ #category : 'changing state' }
SsStateMachine >> changeStateTo: aStateSymbol on: anEvent [
	| state |
	state := self stateAt: aStateSymbol.
	state currentEvent: anEvent.
	self updateCurrentState: state.
]

{ #category : 'accessing' }
SsStateMachine >> context [
	^context ifNil: [context := Dictionary new]
]

{ #category : 'accessing' }
SsStateMachine >> context: anObject [
	context := anObject
]

{ #category : 'accessing' }
SsStateMachine >> currentState [
	^currentState
]

{ #category : 'accessing' }
SsStateMachine >> currentState: aState [
	currentState := aState
]

{ #category : 'debugging' }
SsStateMachine >> debug: anObject [ 
	SsDebugLogger default debug: anObject
]

{ #category : 'event handling' }
SsStateMachine >> handleEvent: anEventSymbolOrEvent [ 
	^self handleEvent: anEventSymbolOrEvent ifFailed: []
]

{ #category : 'event handling' }
SsStateMachine >> handleEvent: anEventSymbolOrEvent ifFailed: aBlock [
	| evt |
	evt := anEventSymbolOrEvent isString ifTrue: [(SsEvent type: anEventSymbolOrEvent)] ifFalse: [anEventSymbolOrEvent].
	^self basicHandleEvent: evt ifFailed: aBlock
]

{ #category : 'testing' }
SsStateMachine >> hasStates [
	^self stateDict size > 0
]

{ #category : 'testing' }
SsStateMachine >> hasTransitions [
	^self transDict size > 0
]

{ #category : 'initialize-release' }
SsStateMachine >> initialize [
	self addState: SsEndState new.
	
]

{ #category : 'accessing' }
SsStateMachine >> listeners [
	^listeners ifNil: [listeners := OrderedCollection new]
]

{ #category : 'accessing' }
SsStateMachine >> listeners: anOrderedCollection [
	listeners := anOrderedCollection
]

{ #category : 'accessing' }
SsStateMachine >> recurCurrentState [
	| state |
	state := self currentState.
	state ifNil: [^ self].
	[state hasSubStates]
		whileTrue: [state := state currentSubState].
	^ state
]

{ #category : 'actions' }
SsStateMachine >> reset [
	self currentState: self startState
]

{ #category : 'actions' }
SsStateMachine >> setAutoFrom: stateId to: nextStateId [
	|  state trans transId |
	state := self stateAt: stateId.
	state isAuto: true.
	transId := stateId, nextStateId.
	state when: #'_ended' fire: transId.
	trans := (SsTransition nextStateId: nextStateId).
	self transAt: transId put: trans
]

{ #category : 'actions' }
SsStateMachine >> setDecisionFrom: stateId if: aBlockOrMessageSend trueTo: trueStateId falseTo: falseStateId [
	|  state trans transId |
	state := self stateAt: stateId.
	state isAuto: true.
	transId := stateId, trueStateId, falseStateId.
	state when: #'_ended' fire: transId.
	trans := (SsDecision if: aBlockOrMessageSend trueTo: trueStateId falseTo: falseStateId).
	self transAt: transId put: trans
]

{ #category : 'actions' }
SsStateMachine >> setStartStateTo: aStateSymbol [
	self startState: (self stateAt: aStateSymbol).
	self changeStateTo: aStateSymbol
]

{ #category : 'actions' }
SsStateMachine >> start [
	self reset.
	self currentState enter.
	self currentState doActivity
]

{ #category : 'accessing' }
SsStateMachine >> startState [
	^startState
]

{ #category : 'accessing' }
SsStateMachine >> startState: aState [
	startState := aState
]

{ #category : 'actions-basic' }
SsStateMachine >> stateAt: aStateName [
	^self stateDict at: aStateName ifAbsent:[SsNoSuchState signal: aStateName asString]
]

{ #category : 'actions-basic' }
SsStateMachine >> stateAt: aStateName ifAbsent: aBlock [
	^self stateDict at: aStateName ifAbsent: aBlock
]

{ #category : 'actions-basic' }
SsStateMachine >> stateAt: aStateName put: aState [
	aState stateMachine: self.
	^self stateDict at: aStateName put: aState
]

{ #category : 'accessing' }
SsStateMachine >> stateDict [
	^stateDict ifNil: [stateDict := IdentityDictionary new]
]

{ #category : 'accessing' }
SsStateMachine >> stateDict: aState [
	stateDict := aState
]

{ #category : 'actions-basic' }
SsStateMachine >> transAt: aTransitionId [
	^self transAt: aTransitionId ifAbsent: [SsNoSuchTransition signal: aTransitionId]
]

{ #category : 'actions-basic' }
SsStateMachine >> transAt: aTransitionId ifAbsent: aBlock [
	^self transDict at: aTransitionId ifAbsent: aBlock
]

{ #category : 'actions-basic' }
SsStateMachine >> transAt: aTransitionId put: aTransition [
	aTransition stateMachine: self.
	^self transDict at: aTransitionId put: aTransition
]

{ #category : 'accessing' }
SsStateMachine >> transDict [
	^transDict ifNil: [transDict := IdentityDictionary new]
]

{ #category : 'accessing' }
SsStateMachine >> transDict: aState [
	transDict := aState
]

{ #category : 'private' }
SsStateMachine >> updateCurrentState: aState [
	self currentState: aState.
	aState enter.
	aState doActivity.
	
]
