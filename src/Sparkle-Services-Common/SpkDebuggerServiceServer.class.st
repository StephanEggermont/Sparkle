Class {
	#name : 'SpkDebuggerServiceServer',
	#superclass : 'SpkDebuggerService',
	#instVars : [
		'tool'
	],
	#category : 'Sparkle-Services-Common'
}

{ #category : 'other' }
SpkDebuggerServiceServer class >> forTool: aTool [

	^ self new
		  initializeFromTool: aTool;
		  yourself
]

{ #category : 'other' }
SpkDebuggerServiceServer >> initializeFramesFromTool [

	frames := tool frames collect: [ :frameTool | 
		          (SpkDebuggerFrameDescriptionServiceServer forTool:
				           frameTool)
			          parentService: self;
			          yourself ]
]

{ #category : 'other' }
SpkDebuggerServiceServer >> initializeFromTool: aTool [

	tool := aTool.
	self refreshFromTool
]

{ #category : 'other' }
SpkDebuggerServiceServer >> refreshFromTool [

	exceptionDescription := tool exceptionDescription.
	processName := tool processName.
	processIdentifier := tool processIdentifier.
	processPriority := tool processPriority.
	self initializeFramesFromTool
]
