Class {
	#name : 'SpkEvaluatorServiceServer',
	#superclass : 'SpkEvaluatorService',
	#traits : 'SpkTDebugLocalServer',
	#classTraits : 'SpkTDebugLocalServer classTrait',
	#instVars : [
		'tool'
	],
	#category : 'Sparkle-Services-PharoServer-Services'
}

{ #category : 'visiting' }
SpkEvaluatorServiceServer >> accept [

	"Evaluate my newSourceCode, answer a new service for the result."

	| resultTool resultService |
	tool newSourceCode: newSourceCode.
	resultTool := tool accept.

	self refreshFromTool.
	resultService := self serviceForTool: resultTool.
	^ resultService
]

{ #category : 'initialization' }
SpkEvaluatorServiceServer >> initializeFromTool: evaluatorTool [

	tool := evaluatorTool.
	self refreshFromTool
]

{ #category : 'initialization' }
SpkEvaluatorServiceServer >> refreshFromTool [

	oldSourceCode := tool oldSourceCode.
	newSourceCode := tool newSourceCode
]

{ #category : 'as yet unclassified' }
SpkEvaluatorServiceServer >> serviceForTool: aTool [

	| serviceClass |
	serviceClass := SpkExplorerServiceServer serviceClassForToolClass:
		                aTool class.
	^ serviceClass forTool: aTool
]