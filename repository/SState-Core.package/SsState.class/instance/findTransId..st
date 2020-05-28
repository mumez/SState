private
findTransId: anEvent 
	| transId |
	transId := self transDict
				at: anEvent type
				ifAbsent: [^(SsEventNotSupposed event: anEvent state: self) signal].
	^transId
	