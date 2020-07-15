Class {
	#name : 'SpkListAndStackApplication',
	#superclass : 'SpkApplication',
	#category : 'Sparkle-Experiments'
}

{ #category : 'activation' }
SpkListAndStackApplication class >> applicationName [
	^ 'Toggle panes on and off'
]

{ #category : 'examples' }
SpkListAndStackApplication class >> example [
	<example>
	self open
]

{ #category : 'running' }
SpkListAndStackApplication >> start [
	(SpkListAndPanesPresenter newApplication: self) openWithSpec
]