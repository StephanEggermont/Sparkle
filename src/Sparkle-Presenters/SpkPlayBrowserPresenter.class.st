Class {
	#name : 'SpkPlayBrowserPresenter',
	#superclass : 'SpkPresenter',
	#instVars : [
		'projects',
		'packages',
		'classes',
		'categories',
		'methods',
		'source',
		'metaClass',
		'metaInstance',
		'connection',
		'service'
	],
	#category : 'Sparkle-Presenters-Presenters'
}

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> connectMetaRadioButtons [

	metaInstance whenActivatedDo: [ self updateMethods ].
	metaInstance whenDeactivatedDo: [ self updateMethods ].
	metaClass whenChangedDo: [ self updateMethods ]
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> connectPresenters [

	projects whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :sparkleService | 
			self getPackagesForProject: sparkleService ] ].
	packages whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :sparkleService | 
			self getClassesForPackage: sparkleService ] ].
	classes whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :sparkleService | 
			self getCategoriesForClass: sparkleService.
			self getMethodsForClass: sparkleService ] ].
	categories whenSelectionChangedDo: [ :selection | 
		self getMethodsForClass: classes selectedItem ].
	methods whenSelectionChangedDo: [ :selection | 
		selection selectedItem ifNotNil: [ :sparkleService | 
			self getSourceForMethod: sparkleService ] ].
	self connectMetaRadioButtons
]

{ #category : 'list management' }
SpkPlayBrowserPresenter >> getCategoriesForClass: classSparkleService [

	| sparkleServices classService categoryStrings |
	classSparkleService ifNil: [ ^self ]. 
	classSparkleService blobPropertyNamed: #meta put: metaClass state.  
	sparkleServices := service
		                   remotePerformOnService: classSparkleService
		                   selector: #update
		                   arguments: #(  ).
	classService := sparkleServices detect: [ :sparkleService | 
		                sparkleService rowanServiceClassName
		                = #RowanClassService ].
	categoryStrings := classService blobPropertyNamed: #categories.
	categories
		items: categoryStrings;
		sortingBlock: [ :a :b | a < b ]
]

{ #category : 'list management' }
SpkPlayBrowserPresenter >> getClassesForPackage: packageSparkleService [

	| sparkleServices packageService classServices |
	sparkleServices := service
		                   remotePerformOnService: packageSparkleService
		                   selector: #update
		                   arguments: #(  ).
	packageService := sparkleServices detect: [ :sparkleService | 
		                   sparkleService rowanServiceClassName
		                   = #RowanPackageService ].
	classServices := packageService blobPropertyNamed: #classes. 
	classes
		items: classServices;
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ]
]

{ #category : 'list management' }
SpkPlayBrowserPresenter >> getMethodsForClass: classSparkleService [

	| sparkleServices classService methodServices displayedMethodServices |
	classSparkleService ifNil: [ ^self ]. 
	classSparkleService blobPropertyNamed: #meta put: metaClass state.  
	sparkleServices := service
		                   remotePerformOnService: classSparkleService
		                   selector: #update
		                   arguments: #(  ).
	classService := sparkleServices detect: [ :sparkleService | 
		                sparkleService rowanServiceClassName
		                = #RowanClassService ].
	methodServices := classService blobPropertyNamed: #methods.
	displayedMethodServices := categories selectedItems isEmpty
		                           ifTrue: [ methodServices ]
		                           ifFalse: [ 
			                           methodServices select: [ :methodService | 
				                           categories selectedItems includes:
					                           (methodService blobPropertyNamed:
						                            #category) ] ].
	methods
		items: displayedMethodServices;
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #selector) < (b blobPropertyNamed: #selector) ]
]

{ #category : 'list management' }
SpkPlayBrowserPresenter >> getPackagesForProject: projectSparkleService [

	| sparkleServices projectService packageServices |
	sparkleServices := service
		                   remotePerformOnService: projectSparkleService
		                   selector: #update
		                   arguments: #(  ).
	projectService := sparkleServices detect: [ :sparkleService | 
		                   sparkleService rowanServiceClassName
		                   = #RowanProjectService ].
	packageServices := projectService blobPropertyNamed: #packages. 
	packages
		items: packageServices;
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ]
]

{ #category : 'list management' }
SpkPlayBrowserPresenter >> getSourceForMethod: methodSparkleService [
	"This probably doesn't really update. Need to fix. "
	service
		remotePerformOnService: methodSparkleService
		selector: #update
		arguments: #(  ).
	source text: (methodSparkleService blobPropertyNamed: #source)
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initialize [
	super initialize.
	service := SpkRowanServiceClient new registerWith:
		           SpkLauncherPresenter connection.
	self initializeProjects 
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initializeListNamed: string in: box [

	| newList |
	box
		add: (SpkBoxLayout newVertical
				 add: (newList := self newList
						             headerTitle: string;
						             yourself);
				 yourself)
		withConstraints: [ :constraints | constraints width: 200 ].
	^ newList
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initializeListPresenters [

	| box |
	self layout add: (box := SpkBoxLayout newHorizontal).
	projects := self initializeListNamed: 'Projects' in: box.
	packages := self initializeListNamed: 'Packages' in: box.
	packages display: [ :sparkleService | 
		sparkleService blobPropertyNamed: #name ].
	classes := self initializeListNamed: 'Classes' in: box.
	classes display: [ :sparkleService | 
		sparkleService blobPropertyNamed: #name ].
	categories := self initializeListNamed: 'Categories' in: box.
	categories beMultipleSelection. 
	methods := self initializeListNamed: 'Methods' in: box.
	methods display: [ :sparkleService | 
		sparkleService blobPropertyNamed: #selector ]
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initializeMetaPresenter [

	| box |
	box := SpBoxLayout newHorizontal
		       add: (metaInstance := self newRadioButton);
		       add: (metaClass := self newRadioButton);
		       yourself.
	metaInstance label: 'Instance'.
	metaInstance associatedRadioButtons: { metaClass }.
	metaClass label: 'Class'.
	self layout add: box withConstraints: [ :constraints | 
		constraints
			width: 175;
			height: 25 ]
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initializePresenters [

	super initializePresenters.
	self initializeListPresenters.
	self initializeMetaPresenter. 
	self initializeSourcePresenter.
	
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initializeProjects [

	| sparkleServices projectServices |
	sparkleServices := service
		                   remotePerformOn: 'RowanBrowserService'
		                   selector: #updateProjects
		                   arguments: #(  ).
	projectServices := sparkleServices select: [ :sparkleService | 
		                   sparkleService rowanServiceClassName
		                   = #RowanProjectService ].
	projects
		items: projectServices;
		display: [ :sparkleService | 
			sparkleService blobPropertyNamed: #name ];
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ]
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initializeSourcePresenter [

	self layout add: (source := self newCode)
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Sparkle Browser';
		borderColor: Color purple;
		borderWidth: 3;
		initialExtent: 1000 @ 600
]

{ #category : 'constants' }
SpkPlayBrowserPresenter >> labelHeight [

	^20
]

{ #category : 'accessing' }
SpkPlayBrowserPresenter >> newLayout [

	^ SpkBoxLayout newVertical
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> updateMethods [

	self getCategoriesForClass: classes selectedItem.
	self getMethodsForClass: classes selectedItem
]
