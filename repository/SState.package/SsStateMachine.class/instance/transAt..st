actions-basic
transAt: aTransitionId
	^self transAt: aTransitionId ifAbsent: [SsNoSuchTransition signal: aTransitionId]