actions
perform
	^ self action ifNotNil: [:act | act cull: self context cull: self currentEvent] 
