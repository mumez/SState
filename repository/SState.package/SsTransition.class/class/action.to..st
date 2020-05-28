instance creation
action: aBlockOrMessageSend to: nextStateId
	| inst |
	inst := self nextStateId: nextStateId.
	inst action: aBlockOrMessageSend.
	^inst