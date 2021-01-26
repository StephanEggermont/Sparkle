Class {
	#name : 'SpkMethodChangedAnnouncement',
	#superclass : 'Announcement',
	#instVars : [
		'methodSparkleService'
	],
	#category : 'Sparkle-Presenters-Presenters'
}

{ #category : 'accessing' }
SpkMethodChangedAnnouncement >> methodSparkleService [

	^ methodSparkleService
]

{ #category : 'accessing' }
SpkMethodChangedAnnouncement >> methodSparkleService: anObject [

	methodSparkleService := anObject
]
