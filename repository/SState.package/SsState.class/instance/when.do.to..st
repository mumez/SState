actions-event
when: anEventOrSymbol do: transitionAction to: nextStateId
	self when: anEventOrSymbol doTransition: (SsTransition action: transitionAction to: nextStateId) 