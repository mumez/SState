event handling
handleEvent: anEventSymbolOrEvent ifFailed: aBlock
	| evt |
	evt := anEventSymbolOrEvent isString ifTrue: [(SsEvent type: anEventSymbolOrEvent)] ifFalse: [anEventSymbolOrEvent].
	^self basicHandleEvent: evt ifFailed: aBlock