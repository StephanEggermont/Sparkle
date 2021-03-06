Class {
	#name : 'SpkInspectorServiceClient',
	#superclass : 'SpkInspectorService',
	#traits : 'SpkTModel',
	#classTraits : 'SpkTModel classTrait',
	#category : 'Sparkle-Services-PharoClient-Services'
}

{ #category : 'adding' }
SpkInspectorServiceClient >> addEvaluator [

	| newEvaluator |
	newEvaluator := SpkEvaluatorServiceClient new
		                registerWith: self connection;
		                parentService: self;
		                evaluationContext: self;
		                yourself.

	evaluators add: newEvaluator.
	^ newEvaluator
]

{ #category : 'removing' }
SpkInspectorServiceClient >> removeEvaluator: anEvaluator [

	evaluators remove: anEvaluator
]
