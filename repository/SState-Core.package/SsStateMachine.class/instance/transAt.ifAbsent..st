actions-basic
transAt: aTransitionId ifAbsent: aBlock
	^self transDict at: aTransitionId ifAbsent: aBlock