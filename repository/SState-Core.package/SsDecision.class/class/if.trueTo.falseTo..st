instance creation
if: aBlockOrMessageSend trueTo: trueStateId falseTo: falseStateId
	| inst |
	inst := self new.
	inst action: aBlockOrMessageSend.
	inst trueStateId: trueStateId.
	inst falseStateId: falseStateId.
	^inst