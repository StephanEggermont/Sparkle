Class {
	#name : 'SparklePlayBrowser',
	#superclass : 'SpkApplication',
	#category : 'Sparkle-Application'
}

{ #category : 'examples' }
SparklePlayBrowser class >> example [ 
	self new start
]

{ #category : 'world menu' }
SparklePlayBrowser class >> menuCommandOn: aBuilder [ 
	"Add a custom menu item to the world menu"	
	<worldMenu> 
	
	(aBuilder item: #'Sparkle Browser')
		order: 0.85; 
		icon: nil;  
		parent: #'Tools';
		keyText: 'o, g'; "hot key doesn't work yet" 
		help: 'Sparkle Experimental Browser that wraps Jadeite/Rowan services';
		action: [ self new start ]
]

{ #category : 'running' }
SparklePlayBrowser >> start [

	^ (self new: SpkPlayBrowserPresenter) openWithSpec
]
