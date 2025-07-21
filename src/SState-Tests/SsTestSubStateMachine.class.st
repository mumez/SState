Class {
	#name : 'SsTestSubStateMachine',
	#superclass : 'SsStateMachine',
	#instVars : [
		'changes'
	],
	#category : 'SState-Tests',
	#package : 'SState-Tests'
}

{ #category : 'accessing' }
SsTestSubStateMachine >> changes [
	^changes
]

{ #category : 'initialize-release' }
SsTestSubStateMachine >> initialize [

	changes := OrderedCollection new.

	(self addStateNamed: #state1) when: #event12 do: [self changes add: 'ss1->ss2'] to: #state2.
	(self addStateNamed: #state2) when: #event21 do: [self changes add: 'ss2->ss1'] to: #state1.
	
	self setStartStateTo: #state1
]
