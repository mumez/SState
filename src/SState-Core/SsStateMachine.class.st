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
	context isNil ifTrue: [context := Dictionary new].
	^context
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
	listeners isNil ifTrue:[ listeners := OrderedCollection new].
	^listeners
]

{ #category : 'accessing' }
SsStateMachine >> listeners: anOrderedCollection [
	listeners := anOrderedCollection
]

{ #category : 'accessing' }
SsStateMachine >> recurCurrentState [
	| state |
	state := self currentState.
	state isNil
		ifTrue: [^ self].
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
	stateDict isNil ifTrue:[stateDict := IdentityDictionary new].
	^stateDict
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
	transDict isNil ifTrue:[transDict := IdentityDictionary new].
	^transDict
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
