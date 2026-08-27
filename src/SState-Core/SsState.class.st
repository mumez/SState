"
I represent a single state in a state machine: I know my outgoing transitions and optional entry/exit/activity actions, and I may nest a sub-state machine.

Responsibility:
- I map event types to transition ids (transDict) and activate the matching transition when an event arrives
- I run optional entryAction/exitAction/activity blocks on enter, exit, and while active
- I may own a nested subStateMachine, delegating unhandled events and lifecycle calls (enter/exit) to it

Collaborators:
- SsTransition: I look up the transition matching an incoming event's type and activate it via #activateTransitionAt:for:
- SsStateMachine: my owner; I ask it for transitions by id and hand off unhandled events to my subStateMachine (itself an SsStateMachine)
- SsEvent: I inspect #type to find the right transition and mark it #handled: true once activated
- SsEventNotSupposed: signaled (as a Warning) when an event's type has no registered transition

Public API and Key Messages:
- #when:to: / #when:do:to: / #when:guarded:...to: - declare a transition from me to another state, optionally guarded/with an action
- #endWhen: / #endWhen:guarded: - declare a transition to the shared end state
- #enter / #exit / #doActivity - lifecycle hooks invoked by the owning state machine on state changes
- #isAuto / #isAuto: - marks a state that fires '_ended' automatically after its activity, enabling automatic transitions

Implementation Points:
- transDict is lazily initialized as an IdentityDictionary keyed by event type symbol
- hasSubStates delegates to the nested subStateMachine when present, enabling hierarchical (nested) states
"
Class {
	#name : 'SsState',
	#superclass : 'SsObject',
	#instVars : [
		'transDict',
		'subStateMachine',
		'entryAction',
		'exitAction',
		'activity',
		'isAuto'
	],
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'instance creation' }
SsState class >> named: stateName [
	^self id: stateName
]

{ #category : 'instance creation' }
SsState class >> named: stateName on: stateMachine [
	| inst |
	inst := self named: stateName.
	stateMachine addState: inst.
	^inst
]

{ #category : 'private' }
SsState >> activateTransitionAt: transId for: anEvent [
	| trans | 
			trans := self stateMachine
						transAt: transId
						ifAbsent: [^SsNoSuchTransition signal: transId printString].
			trans currentEvent: anEvent.
			(trans checkGuard)
				ifTrue: [self currentEvent: anEvent.
					self exit.
					trans activate.
					anEvent handled: true]
]

{ #category : 'accessing' }
SsState >> activity [
	^ activity
]

{ #category : 'accessing' }
SsState >> activity: aBlockOrMessageSend [
	activity := aBlockOrMessageSend
]

{ #category : 'event handling' }
SsState >> basicHandleEvent: anEvent [ 
	| transId |
	transId := self findTransId: anEvent.
	transId isNil ifFalse: [self activateTransitionAt: transId for: anEvent].
	(anEvent handled not and: [self subStateMachine notNil]) ifTrue: [self subStateMachine handleEvent: anEvent]
]

{ #category : 'accessing-substates' }
SsState >> currentSubState [
	^self subStateMachine currentState
]

{ #category : 'state-actions' }
SsState >> doActivity [
	self debug: '#doActivity'.
	self activity ifNotNil: [:act | act cull: self context cull: self currentEvent].
	self isAuto ifTrue: [self handleEvent: #'_ended'].

]

{ #category : 'actions-event' }
SsState >> endWhen: anEventOrSymbol [
	self when: anEventOrSymbol doTransition: (SsEndTransition new) 
]

{ #category : 'actions-event' }
SsState >> endWhen: anEventOrSymbol guarded: guardCondition [
	| trans |
	trans := SsEndTransition new.
	trans guardCondition: guardCondition.
	self when: anEventOrSymbol doTransition: trans 
]

{ #category : 'state-actions' }
SsState >> enter [
	self debug: '#enter'.
	self entryAction ifNotNil: [:act | act cull: self context cull: self currentEvent].
	self subStateMachine notNil
		ifTrue: [self subStateMachine start]
]

{ #category : 'accessing' }
SsState >> entryAction [
	^ entryAction
]

{ #category : 'accessing' }
SsState >> entryAction: aBlockOrMessageSend [
	entryAction := aBlockOrMessageSend
]

{ #category : 'state-actions' }
SsState >> exit [
	self debug: '#exit'.
	self exitAction ifNotNil: [:act | act cull: self context cull: self currentEvent].
	self subStateMachine notNil
		ifTrue: [self subStateMachine currentState exit.
				self subStateMachine reset]
]

{ #category : 'accessing' }
SsState >> exitAction [
	^ exitAction
]

{ #category : 'accessing' }
SsState >> exitAction: aBlockOrMessageSend [
	exitAction := aBlockOrMessageSend
]

{ #category : 'private' }
SsState >> findTransId: anEvent [ 
	| transId |
	transId := self transDict
				at: anEvent type
				ifAbsent: [^(SsEventNotSupposed event: anEvent state: self) signal].
	^transId
	
]

{ #category : 'event handling' }
SsState >> handleEvent: anEventSymbolOrEvent [ 
	| evt |
	evt := anEventSymbolOrEvent isString ifTrue: [(SsEvent type: anEventSymbolOrEvent)] ifFalse: [anEventSymbolOrEvent].
	^self basicHandleEvent: evt
]

{ #category : 'accessing-substates' }
SsState >> hasSubStates [
	^self subStateMachine notNil and:[self subStateMachine hasStates]
	
]

{ #category : 'accessing' }
SsState >> isAuto [
	^ isAuto ifNil: [isAuto := false]
]

{ #category : 'accessing' }
SsState >> isAuto: anObject [
	isAuto := anObject
]

{ #category : 'accessing' }
SsState >> name [
	^self id
]

{ #category : 'accessing' }
SsState >> subStateMachine [
	^subStateMachine
]

{ #category : 'accessing' }
SsState >> subStateMachine: aStateMachine [
	subStateMachine := aStateMachine
]

{ #category : 'accessing' }
SsState >> transDict [
	transDict isNil ifTrue: [ transDict := IdentityDictionary new].
	^transDict
]

{ #category : 'actions-event' }
SsState >> when: anEventOrSymbol do: transitionAction to: nextStateId [
	self when: anEventOrSymbol doTransition: (SsTransition action: transitionAction to: nextStateId) 
]

{ #category : 'actions-events-basic' }
SsState >> when: anEventOrSymbol doTransition: aTransition [ 
	| eventType |
	eventType := anEventOrSymbol isString ifTrue: [anEventOrSymbol] ifFalse: [anEventOrSymbol type].
	self when: eventType fire: aTransition id.
	self stateMachine addTransition: aTransition.
]

{ #category : 'actions-events-basic' }
SsState >> when: anEventTypeSymbol fire: aTransitionSymbol [
	^self transDict at: anEventTypeSymbol put: aTransitionSymbol
]

{ #category : 'actions-event' }
SsState >> when: anEventOrSymbol guarded: guardCondition do: transitionAction to: nextStateId [
	self when: anEventOrSymbol doTransition: (SsTransition guarded: guardCondition action: transitionAction to: nextStateId) 
]

{ #category : 'actions-event' }
SsState >> when: anEventOrSymbol guarded: guardCondition to: nextStateId [
	| trans |
	trans := SsTransition nextStateId: nextStateId.
	trans guardCondition: guardCondition.
	self when: anEventOrSymbol doTransition: (trans) 
]

{ #category : 'actions-event' }
SsState >> when: anEventOrSymbol to: nextStateId [
	self when: anEventOrSymbol doTransition: (SsTransition nextStateId: nextStateId) 
]
