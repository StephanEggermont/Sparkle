Class {
	#name : 'SpkColumnLayoutServiceServer',
	#superclass : 'SpkColumnLayoutService',
	#instVars : [
		'tool'
	],
	#category : 'Sparkle-Services-Common'
}

{ #category : 'instance creation' }
SpkColumnLayoutServiceServer class >> forTool: aColumnLayoutTool [

	^ self new
		  initializeFromTool: aColumnLayoutTool;
		  yourself
]

{ #category : 'initialization' }
SpkColumnLayoutServiceServer >> initializeFromTool: aColumnLayoutTool [

	tool := aColumnLayoutTool.
	relativeWidth := tool relativeWidth
]

{ #category : 'initialization' }
SpkColumnLayoutServiceServer >> initializePanesForExplorer: xServ [

	paneLayouts := OrderedCollection new.
	tool paneLayouts do: [ :plTool | 
		| plServ pServ |
		plServ := SpkPaneLayoutServiceServer forTool: plTool.
		pServ := xServ paneServiceForTool: plTool paneTool.
		plServ paneService: pServ.

		paneLayouts add: plServ.
		xServ addPaneService: pServ ]
]
