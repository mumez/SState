actions
setAutoFrom: stateId to: nextStateId
	|  state trans transId |
	state := self stateAt: stateId.
	state isAuto: true.
	transId := stateId, nextStateId.
	state when: #'_ended' fire: transId.
	trans := (SsTransition nextStateId: nextStateId).
	self transAt: transId put: trans