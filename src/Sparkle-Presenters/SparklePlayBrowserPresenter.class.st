Class {
	#name : 'SparklePlayBrowserPresenter',
	#superclass : 'SpkPresenter',
	#instVars : [
		'projects',
		'packages',
		'classes'
	],
	#category : 'Sparkle-Presenters-Presenters'
}

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeListPresenters [

	projects := self newList.
	self layout add: (SpkBoxLayout newVertical
			 color: Color purple lighter;
			 add: 'Projects'
			 withConstraints: [ :constraints | 
				 constraints height: self labelHeight ];
			 add: projects;
			 yourself).

	self layout add: (SpBoxLayout newVertical
			 add: 'Packages'
			 withConstraints: [ :constraints | 
				 constraints height: self labelHeight ];
			 add: (packages := self newList);
			 yourself).
	self layout add: (SpBoxLayout newVertical
			 add: 'Classes'
			 withConstraints: [ :constraints | 
				 constraints height: self labelHeight ];
			 add: (classes := self newList);
			 yourself).
	self layout add: (SpBoxLayout newVertical
			 add: 'Categories'
			 withConstraints: [ :constraints | 
				 constraints height: self labelHeight ];
			 add: (classes := self newList);
			 yourself).
	self layout add: (SpBoxLayout newVertical
			 add: 'Methods'
			 withConstraints: [ :constraints | 
				 constraints height: self labelHeight ];
			 add: (classes := self newList);
			 yourself)
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializePresenters [

	super initializePresenters.
	self initializeListPresenters.
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Sparkle Browser';
		initialExtent: 600 @ 400
	
]

{ #category : 'constants' }
SparklePlayBrowserPresenter >> labelHeight [

	^20
]

{ #category : 'accessing' }
SparklePlayBrowserPresenter >> newLayout [

	^ SpkBoxLayout newHorizontal
]
