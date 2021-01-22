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
		'toolbar',
		'connection',
		'service',
		'lowerTabs',
		'classDefinition'
	],
	#category : 'Sparkle-Presenters-Presenters'
}

{ #category : 'actions' }
SpkPlayBrowserPresenter >> abortTransaction [

	service
		remotePerformOn: #RowanAnsweringService
		selector: #exec:
		arguments: #( 'System abortTransaction' ).
	self resetListsRetainingSelections. 
	self inform: 'Aborted transaction'
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> addClassDefinitionPage [

	^ SpNotebookPage title: 'Class Definition' icon: nil provider: [ 
		  classDefinition := self instantiate: SpkCodePresenter.
		  classDefinition whenSubmitDo: [ :text | 
			  self
				  saveClass: classes selectedItem
				  definition: classDefinition text asString ].
		  classDefinition ]
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> addMethodSourcePage [

	source := self instantiate: SpkCodePresenter.
	source whenSubmitDo: [ :text | 
		self
			saveMethod: classes selectedItem
			category: categories selectedItem ].
	^ SpNotebookPage
		  title: 'Method Source'
		  icon: nil
		  provider: [ source ]
]

{ #category : 'actions' }
SpkPlayBrowserPresenter >> commitTransaction [

	service
		remotePerformOn: #RowanAnsweringService
		selector: #exec:
		arguments: #( 'System commitTransaction' ).
	self inform: 'Committed transaction'
]

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
			self updateClassInfoFrom: sparkleService ] ].
	categories whenSelectionChangedDo: [ :selection | 
		self
			getMethodsForClass: classes selectedItem
			shouldRetainSelections: false ].
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
		sortingBlock: [ :a :b | a < b ].
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
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ].
	categories items: OrderedCollection new.
	methods items: OrderedCollection new
]

{ #category : 'list management' }
SpkPlayBrowserPresenter >> getMethodsForClass: classSparkleService shouldRetainSelections: shouldRetainSelections [

	| sparkleServices classService methodServices displayedMethodServices selections |
	classSparkleService ifNil: [ ^ self ].
	shouldRetainSelections ifTrue: [ 
		selections := methods selection selectedItems collect: [ 
			              :methodService | 
			              methodService blobPropertyNamed: #selector ] ].
	classSparkleService blobPropertyNamed: #meta put: metaClass state.
	sparkleServices := service
		                   remotePerformOnService: classSparkleService
		                   selector: #update
		                   arguments: #(  ).
	classService := sparkleServices detect: [ :sparkleService | 
		                sparkleService rowanServiceClassName
		                = #RowanClassService ].
	methodServices := classService blobPropertyNamed: #methods.
	displayedMethodServices := self methodsInSelectedCategory:
		                           methodServices.
	methods
		items: displayedMethodServices;
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #selector) < (b blobPropertyNamed: #selector) ].
	shouldRetainSelections ifTrue: [ 
		methods disableActivationDuring: [ 
			| toBeSelected |
			toBeSelected := methods items select: [ :methodService | 
				                selections includes:
					                (methodService blobPropertyNamed: #selector) ].
			methods selectItems: toBeSelected ] ]
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
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ].
	classes items: OrderedCollection new.
	categories items: OrderedCollection new. 
	methods items: OrderedCollection new. 
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
	box add: (SpkBoxLayout newVertical
			 add: (newList := self newList
					             headerTitle: string;
					             yourself);
			 yourself).
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
		sparkleService blobPropertyNamed: #selector ].
	methods beMultipleSelection
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> initializeLowerTabs [

	lowerTabs := self newNotebook.
	lowerTabs addPage: self addClassDefinitionPage.
	lowerTabs addPage: self addMethodSourcePage.
	self layout add: lowerTabs
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
	self initializeToolbar.
	self initializeListPresenters.
	self initializeMetaPresenter. 
	self initializeLowerTabs. 
	
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
SpkPlayBrowserPresenter >> initializeToolbar [

	toolbar := self newToolbar
		           addItem: (SpToolbarButtonPresenter new
				            label: 'Abort';
				            icon: (self iconNamed: #thumbsDown);
				            help: 'Abort';
				            action: [ self abortTransaction ];
				            yourself);
		           addItem: (SpToolbarButtonPresenter new
				            label: 'Commit';
				            icon: (self iconNamed: #thumbsUp);
				            help: 'Commit';
				            action: [ self commitTransaction ];
				            yourself);
		           yourself.
	self layout
		add: toolbar
		withConstraints: [ :constraints | constraints height: 30 ]
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

{ #category : 'list management' }
SpkPlayBrowserPresenter >> methodsInSelectedCategory: methodServices [

	^ categories selectedItems isEmpty
		  ifTrue: [ methodServices ]
		  ifFalse: [ 
			  methodServices select: [ :methodService | 
				  categories selectedItems includes:
					  (methodService blobPropertyNamed: #category) ] ]
]

{ #category : 'accessing' }
SpkPlayBrowserPresenter >> newLayout [

	^ SpkBoxLayout newVertical
]

{ #category : 'private-actions' }
SpkPlayBrowserPresenter >> presenterLists [

	^ Array
		  with: projects
		  with: packages
		  with: classes
		  with: categories
		  with: methods
]

{ #category : 'private-actions' }
SpkPlayBrowserPresenter >> resetListRetainingSelections: listPresenter [

	listPresenter disableActivationDuring: [ 
		| selections |
		selections := listPresenter selection selectedItems.
		listPresenter items: listPresenter items.
		listPresenter selectItems: selections ]
]

{ #category : 'private-actions' }
SpkPlayBrowserPresenter >> resetListsRetainingSelections [

	self
		getMethodsForClass: classes selection selectedItem
		shouldRetainSelections: true
]

{ #category : 'actions' }
SpkPlayBrowserPresenter >> saveClass: classSparkleService definition: definitionString [

	| classService sparkleServices |
	true ifTrue:[^self]. "not working yet"
	sparkleServices := service
		                   remotePerformOn: #RowanBrowserService
		                   selector: #compileClass:
		                   arguments: (Array with: definitionString).
	classService := sparkleServices detect: [ :sparkleService | 
		                sparkleService rowanServiceClassName
		                = #RowanClassService ].
	source text: (classService blobPropertyNamed: #template).
	classes
		items: classes items , (Array with: classService);
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #name) < (b blobPropertyNamed: #name) ].
	methods selectItem: classService.
	methods verticalAlignment desiredVisibleRow:
		(methods items size min: (methods items indexOf: classService))
]

{ #category : 'actions' }
SpkPlayBrowserPresenter >> saveMethod: classSparkleService category: category [

	| methodService sparkleServices |
	sparkleServices := service
		                   remotePerformOnService: classSparkleService
		                   selector: #saveMethodSource:category:
		                   arguments:
		                   (Array with: source text asString with: category).
	methodService := sparkleServices detect: [ :sparkleService | 
		                 sparkleService rowanServiceClassName
		                 = #RowanMethodService ].
	source text: (methodService blobPropertyNamed: #source).
	methods
		items: methods items , (Array with: methodService);
		sortingBlock: [ :a :b | 
			(a blobPropertyNamed: #selector) < (b blobPropertyNamed: #selector) ].
	methods selectItem: methodService.
	methods verticalAlignment desiredVisibleRow:
		(methods items size min: (methods items indexOf: methodService))
]

{ #category : 'private-actions' }
SpkPlayBrowserPresenter >> updateClassInfoFrom: sparkleService [

	classDefinition text: (sparkleService blobPropertyNamed: #template).
	self getCategoriesForClass: sparkleService.
	self getMethodsForClass: sparkleService shouldRetainSelections: false.
	source text: String new. 
]

{ #category : 'initialization' }
SpkPlayBrowserPresenter >> updateMethods [

	self getCategoriesForClass: classes selectedItem.
	self
		getMethodsForClass: classes selectedItem
		shouldRetainSelections: false
]
