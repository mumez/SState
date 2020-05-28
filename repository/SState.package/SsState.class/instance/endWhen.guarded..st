actions-event
endWhen: anEventOrSymbol guarded: guardCondition
	| trans |
	trans := SsEndTransition new.
	trans guardCondition: guardCondition.
	self when: anEventOrSymbol doTransition: trans 