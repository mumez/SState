"
I am a Warning signaled when a state receives an event type it has no transition registered for.

Responsibility:
- I carry the offending event and the state that could not handle it, for diagnostic purposes
- My defaultAction returns nil, so by default I do not interrupt execution when unhandled

Collaborators:
- SsState: signals me from #findTransId: when an event's type is not found in its transition dictionary
- SsEvent: the event instance that triggered me, accessible via #event

Public API and Key Messages:
- SsEventNotSupposed class >> event:state: - creates and configures an instance with the offending event/state
- #event / #state - accessors to inspect what went wrong
"
Class {
	#name : 'SsEventNotSupposed',
	#superclass : 'Warning',
	#instVars : [
		'event',
		'state'
	],
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'instance creation' }
SsEventNotSupposed class >> event: anEvent state: aState [
	^self new event: anEvent; state: aState; yourself
]

{ #category : 'exceptionDescription' }
SsEventNotSupposed >> defaultAction [
	
	^nil
]

{ #category : 'accessing' }
SsEventNotSupposed >> event [
	^ event
]

{ #category : 'accessing' }
SsEventNotSupposed >> event: anObject [
	event := anObject
]

{ #category : 'accessing' }
SsEventNotSupposed >> state [
	^ state
]

{ #category : 'accessing' }
SsEventNotSupposed >> state: anObject [
	state := anObject
]
