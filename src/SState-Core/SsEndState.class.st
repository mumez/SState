Class {
	#name : 'SsEndState',
	#superclass : 'SsState',
	#category : 'SState-Core',
	#package : 'SState-Core'
}

{ #category : 'state-actions' }
SsEndState >> doActivity [
	"NEVER DO ANYTHING"	
]

{ #category : 'state-actions' }
SsEndState >> exit [
	"NEVER DO ANYTHING"	
]

{ #category : 'accessing' }
SsEndState >> id [
	^#endState
]
