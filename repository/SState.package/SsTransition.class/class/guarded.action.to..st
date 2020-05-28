instance creation
guarded: guardCondition action: aBlockOrMessageSend to: nextStateId
	| inst |
	inst := self nextStateId: nextStateId.
	inst guardCondition: guardCondition.
	inst action: aBlockOrMessageSend.
	^inst