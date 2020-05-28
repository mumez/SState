actions-basic
transAt: aTransitionId put: aTransition
	aTransition stateMachine: self.
	^self transDict at: aTransitionId put: aTransition