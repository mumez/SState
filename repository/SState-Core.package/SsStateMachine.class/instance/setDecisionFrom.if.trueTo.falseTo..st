actions
setDecisionFrom: stateId if: aBlockOrMessageSend trueTo: trueStateId falseTo: falseStateId
	|  state trans transId |
	state := self stateAt: stateId.
	state isAuto: true.
	transId := stateId, trueStateId, falseStateId.
	state when: #'_ended' fire: transId.
	trans := (SsDecision if: aBlockOrMessageSend trueTo: trueStateId falseTo: falseStateId).
	self transAt: transId put: trans