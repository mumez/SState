private
basicHandleEvent: anEvent ifFailed: aBlock
	self listeners	do: [:each | each handleEvent: anEvent copy].
		
	self currentState handleEvent: anEvent.
	anEvent handled ifFalse: [
		aBlock cull: self
	].
	