actions-basic
stateAt: aStateName put: aState
	aState stateMachine: self.
	^self stateDict at: aStateName put: aState