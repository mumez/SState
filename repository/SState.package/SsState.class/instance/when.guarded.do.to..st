actions-event
when: anEventOrSymbol guarded: guardCondition do: transitionAction to: nextStateId
	self when: anEventOrSymbol doTransition: (SsTransition guarded: guardCondition action: transitionAction to: nextStateId) 