actions-basic
stateAt: aStateName
	^self stateDict at: aStateName ifAbsent:[SsNoSuchState signal: aStateName asString]