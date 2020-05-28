actions-event
when: anEventOrSymbol to: nextStateId
	self when: anEventOrSymbol doTransition: (SsTransition nextStateId: nextStateId) 