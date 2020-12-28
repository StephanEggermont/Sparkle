Class {
	#name : 'SpkClickyListPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'model',
		'listPane'
	],
	#category : 'Sparkle-Experiments'
}

{ #category : 'specs' }
SpkClickyListPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #listPane;
		yourself
]

{ #category : 'instance creation' }
SpkClickyListPresenter class >> openForApplication: anApplication onModel: aModel [
	^ self basicNew
		application: anApplication;
		setModelBeforeInitialization: aModel;
		initialize;
		openWithSpec;
		yourself
]

{ #category : 'selection' }
SpkClickyListPresenter >> deferItemDeselected: anAnnouncement [

	"This is sent by the model when a previously selected item becomes deselected."

	self defer: [ self itemDeselected: anAnnouncement ]
]

{ #category : 'selection' }
SpkClickyListPresenter >> deferItemSelected: anAnnouncement [

	"This is sent by the model when a previously unselected item becomes selected."

	self defer: [ self itemSelected: anAnnouncement ]
]

{ #category : 'model interaction' }
SpkClickyListPresenter >> hookToModel [
	model when: SpkItemSelected send: #deferItemSelected: to: self.
	model when: SpkItemDeselected send: #deferItemDeselected: to: self.
	listPane items: model items
]

{ #category : 'initialization' }
SpkClickyListPresenter >> initializePresenters [
	listPane := self newList.
	listPane
		whenSelectionChangedDo:
			[ :selectionMode | self listPaneSelectedIndexes: selectionMode selectedIndexes ].
	self focusOrder add: listPane.
	self hookToModel
]

{ #category : 'initialization' }
SpkClickyListPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter
		title: 'ClickyList';
		aboutText: 'Testing list multi-selection';
		whenWillCloseDo: [ self unhookFromModel ]
]

{ #category : 'private' }
SpkClickyListPresenter >> itemDeselected: anAnnouncement [
	"Must only be sent by the UI thread.
	This is sent by the model when a previously selected item becomes deselected."

	| items index |
	items := model items.
	index := items indexOf: anAnnouncement item.
	index = 0
		ifTrue: [ ^ self error: 'Selected item not found.' ].
	listPane unselectIndex: index
]

{ #category : 'private' }
SpkClickyListPresenter >> itemSelected: anAnnouncement [

	"Must be sent only from the UI thread.
	This is sent by the model when a previously unselected item becomes selected."

	| items index |
	items := model items.
	index := items indexOf: anAnnouncement item.
	index = 0 ifTrue: [ ^ self error: 'Selected item not found.' ].
	listPane selectIndex: index
]

{ #category : 'accessing' }
SpkClickyListPresenter >> listPane [
	^ listPane
]

{ #category : 'accessing' }
SpkClickyListPresenter >> listPane: anObject [
	listPane := anObject
]

{ #category : 'model interaction' }
SpkClickyListPresenter >> listPaneSelectedIndexes: newIndexes [
	"Our list pane's selection has changed, notify the model.
	It falls to us to translate between selected indexes and selected objects."

	| items previouslySelectedItems nowSelectedItems newlySelectedItems newlyDeselectedItems |
	items := model items.
	previouslySelectedItems := model selectedItems.
	nowSelectedItems := newIndexes collect: [ :i | items at: i ].
	newlySelectedItems := nowSelectedItems
		difference: previouslySelectedItems.
	newlyDeselectedItems := previouslySelectedItems
		difference: nowSelectedItems.
	newlySelectedItems do: [ :each | model selectItem: each ].
	newlyDeselectedItems do: [ :each | model deselectItem: each ]
]

{ #category : 'widgets' }
SpkClickyListPresenter >> newList [
	^ self instantiate: SpkMultipleSelectionListPresenter
]

{ #category : 'accessing model' }
SpkClickyListPresenter >> setModelBeforeInitialization: aDomainObject [
	model := aDomainObject
]

{ #category : 'model interaction' }
SpkClickyListPresenter >> unhookFromModel [
	model unsubscribe: self
]