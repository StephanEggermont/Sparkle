Class {
	#name : 'SpkTaskspaceLayoutTool',
	#superclass : 'SpkTool',
	#instVars : [
		'explorerLayouts',
		'taskspaceTool'
	],
	#category : 'Sparkle-Tools-Common'
}

{ #category : 'instance creation' }
SpkTaskspaceLayoutTool class >> newDefault [

	^ self new
		  initializeForDefault;
		  yourself
]

{ #category : 'adding' }
SpkTaskspaceLayoutTool >> addExplorerLayout: anExplorerLayoutTool [

	explorerLayouts add: anExplorerLayoutTool
]

{ #category : 'accessing' }
SpkTaskspaceLayoutTool >> explorerLayouts [

	^ explorerLayouts
]

{ #category : 'initialization' }
SpkTaskspaceLayoutTool >> initialize [

	super initialize.
	explorerLayouts := Set new
]

{ #category : 'initialization' }
SpkTaskspaceLayoutTool >> initializeForDefault [

"	| taskspaceTool | -- see https://github.com/GemTalk/Sparkle/issues/9"
	taskspaceTool := SpkTaskspaceTool newDefault.
	self initializeForTool: taskspaceTool
]

{ #category : 'initialization' }
SpkTaskspaceLayoutTool >> initializeForTool: aTaskspaceTool [

	taskspaceTool := aTaskspaceTool.
	explorerLayouts := taskspaceTool explorerTools collect: [ :each | 
		                   SpkExplorerLayoutTool new
			                   initializeForTool: each;
			                   yourself ]
]

{ #category : 'accessing' }
SpkTaskspaceLayoutTool >> taskspaceTool [

	^ taskspaceTool
]
