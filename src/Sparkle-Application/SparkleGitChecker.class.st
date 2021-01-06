"
Checks the Sparkle & RSR repository shas on both client & server.
If the respective shas are equal, a green button is shown.
If there is skew, a red button is shown.

"
Class {
	#name : 'SparkleGitChecker',
	#superclass : 'SpkApplication',
	#category : 'Sparkle-Application'
}

{ #category : 'examples' }
SparkleGitChecker class >> check [
	<example>
	self new start
]

{ #category : 'examples' }
SparkleGitChecker class >> example [ 
	self new start
]

{ #category : 'running' }
SparkleGitChecker >> start [
	(self new: SpkGitCheckerPresenter) openWithSpec
]
