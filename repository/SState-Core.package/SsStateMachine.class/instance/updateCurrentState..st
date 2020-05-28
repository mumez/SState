private
updateCurrentState: aState
	self currentState: aState.
	aState enter.
	aState doActivity.
	