actions-event
when: anEventOrSymbol guarded: guardCondition to: nextStateId
	| trans |
	trans := SsTransition nextStateId: nextStateId.
	trans guardCondition: guardCondition.
	self when: anEventOrSymbol doTransition: (trans) 