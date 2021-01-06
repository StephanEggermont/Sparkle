Class {
	#name : 'SparklePlayBrowser',
	#superclass : 'SpkApplication',
	#category : 'Sparkle-Application'
}

{ #category : 'examples' }
SparklePlayBrowser class >> example [ 
	self new start
]

{ #category : 'running' }
SparklePlayBrowser >> start [

	^ (self new: SparklePlayBrowserPresenter) openWithSpec
]
