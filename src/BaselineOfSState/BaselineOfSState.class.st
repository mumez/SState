Class {
	#name : 'BaselineOfSState',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSState',
	#package : 'BaselineOfSState'
}

{ #category : 'baseline' }
BaselineOfSState >> baseline: spec [
	<baseline>
	spec for: #common do: [ spec
		package: 'SState-Core';
		package: 'SState-Tests' with: [ spec requires: #('SState-Core') ];
		
		group: 'default' with: #('Core' 'Tests');
		group: 'Core' with: #('SState-Core');
		group: 'Tests' with: #('SState-Tests')]
]
