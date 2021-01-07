Class {
	#name : 'SpkRowanServiceServer',
	#superclass : 'SpkRowanService',
	#category : 'Sparkle-Services-Common'
}

{ #category : 'command execution' }
SpkRowanServiceServer >> remotePerformOn: classString selector: selector arguments: anArray meta: meta [

	| theClass commandResultClass rowanServices |
	theClass := GsSession currentSession resolveSymbol:
		            classString asSymbol.
	theClass ifNil: [ ^ self ].
	meta ifTrue: [ theClass := theClass class ].
	theClass perform: selector withArguments: anArray.
	commandResultClass := GsSession currentSession resolveSymbol:
		                      #RowanCommandResult.
	rowanServices := Array new.
	^ commandResultClass results collect: [ :service | 
		  service makeSparkle ]
]
