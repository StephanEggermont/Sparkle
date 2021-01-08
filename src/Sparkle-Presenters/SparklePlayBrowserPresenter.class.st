Class {
	#name : 'SparklePlayBrowserPresenter',
	#superclass : 'SpkPresenter',
	#instVars : [
		'projects',
		'packages',
		'classes',
		'categories',
		'methods',
		'connection',
		'service'
	],
	#category : 'Sparkle-Presenters-Presenters'
}

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initialize [
	super initialize.
	service := SpkRowanServiceClient new registerWith:
		           SpkLauncherPresenter connection.
	self initializeProjects 
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeListNamed: string in: box [

	| newList |
	box
		add: (SpkBoxLayout newVertical
				 add: string
				 withConstraints: [ :constraints | 
					 constraints height: self labelHeight ];
				 add: (newList := self newList);
				 yourself)
		withConstraints: [ :constraints | constraints width: 150].
	^ newList
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeListPresenters [

	| box |
	self layout add: (box := SpkBoxLayout newHorizontal).
	projects := self initializeListNamed: 'Projects' in: box.
	packages := self initializeListNamed: 'Packages' in: box.
	classes := self initializeListNamed: 'Classes' in: box.
	categories := self initializeListNamed: 'Categories' in: box.
	methods := self initializeListNamed: 'Methods' in: box
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializePresenters [

	super initializePresenters.
	self initializeListPresenters.
	self initializeSourcePresenter.
	
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeProjects [

	| sparkleServices projectServices |
	sparkleServices := service
		remotePerformOn: 'RowanBrowserService'
		selector: #updateProjects
		arguments: #(  ). 
	projectServices := sparkleServices select:[:sparkleService | sparkleService rowanServiceClassName = #'RowanProjectService'].
	
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeSourcePresenter [

	self layout add: self newCode
]

{ #category : 'initialization' }
SparklePlayBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Sparkle Browser';
		borderColor: Color purple;
		borderWidth: 3;
		initialExtent: 750 @ 600
]

{ #category : 'constants' }
SparklePlayBrowserPresenter >> labelHeight [

	^20
]

{ #category : 'accessing' }
SparklePlayBrowserPresenter >> newLayout [

	^ SpkBoxLayout newVertical
]
