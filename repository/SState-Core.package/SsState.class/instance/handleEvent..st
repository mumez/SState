event handling
handleEvent: anEventSymbolOrEvent 
	| evt |
	evt := anEventSymbolOrEvent isString ifTrue: [(SsEvent type: anEventSymbolOrEvent)] ifFalse: [anEventSymbolOrEvent].
	^self basicHandleEvent: evt