Class {
	#name : 'SpkDebuggerTool',
	#superclass : 'SpkTool',
	#instVars : [
		'explorerTool',
		'process',
		'exception',
		'frames',
		'debugActionForContinue'
	],
	#category : 'Sparkle-Tools-GemStone'
}

{ #category : 'accessing' }
SpkDebuggerTool >> debugActionForContinue: aBlock [
	"I must restore this block as the debugAction of the debugged process before I let it continue.
	Typically this is the same block that caused me to be created."

	debugActionForContinue := aBlock
]

{ #category : 'accessing' }
SpkDebuggerTool >> exception: anException [
	"The exception that caused me to be invoked."

	exception := anException
]

{ #category : 'accessing' }
SpkDebuggerTool >> exceptionDescription [
	| string |
	string := String new.
	string
		add: exception class name;
		add: self exceptionSpecificMessage.
	^ string
]

{ #category : 'private' }
SpkDebuggerTool >> exceptionSpecificMessage [
	| fullMessage commaIndex latterPart |
	fullMessage := exception buildMessageText.
	fullMessage ifNil: [ ^ '' ].
	commaIndex := fullMessage indexOf: $,.
	latterPart := commaIndex = 0
		ifTrue: [ fullMessage ]
		ifFalse: [ fullMessage copyFrom: commaIndex + 1 to: fullMessage size ].
	^ ' - ' , latterPart
]

{ #category : 'accessing' }
SpkDebuggerTool >> explorerTool [
	^explorerTool
]

{ #category : 'accessing' }
SpkDebuggerTool >> explorerTool: object [
	explorerTool := object
]

{ #category : 'accessing' }
SpkDebuggerTool >> frameAt: anInteger [
	^ self frames at: anInteger
]

{ #category : 'accessing' }
SpkDebuggerTool >> frames [
	^ frames ifNil: [ self initializeFramesFromProcess ]
]

{ #category : 'initialization' }
SpkDebuggerTool >> initializeFramesFromProcess [
	| stackDepth |
	stackDepth := process stackDepth.
	frames := Array new: process stackDepth.
	1 to: stackDepth do: [ :level | 
		| frame index |
		index := stackDepth - level + 1.
		frame := SpkDebuggerFrameTool new.
		frame
			explorerTool: explorerTool;
			process: process;
			level: level;
			index: index.
		frames at: index put: frame ].
	^ frames
]

{ #category : 'accessing' }
SpkDebuggerTool >> process: aProcess [
	"The GsProcess that I am to debug."

	process := aProcess
]

{ #category : 'accessing' }
SpkDebuggerTool >> processIdentifier [
	^ SpkReflection identifierOf: process
]

{ #category : 'accessing' }
SpkDebuggerTool >> processName [
	^ process name
]

{ #category : 'accessing' }
SpkDebuggerTool >> processPriority [
	^ process priority
]
