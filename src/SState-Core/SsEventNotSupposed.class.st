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
