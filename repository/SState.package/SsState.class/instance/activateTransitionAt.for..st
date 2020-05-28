private
activateTransitionAt: transId for: anEvent
	| trans | 
			trans := self stateMachine
						transAt: transId
						ifAbsent: [^SsNoSuchTransition signal: transId printString].
			trans currentEvent: anEvent.
			(trans checkGuard)
				ifTrue: [self currentEvent: anEvent.
					self exit.
					trans activate.
					anEvent handled: true]