Class {
	#name : 'SpkRowanService',
	#superclass : 'RsrService',
	#category : 'Sparkle-Services-Common'
}

{ #category : 'accessing' }
SpkRowanService class >> templateClassName [

	^ #SpkRowanService
]

{ #category : 'command execution' }
SpkRowanService >> remotePerformOn: classString selector: selector arguments: anArray meta: meta [
	| theClass commandResultClass |
	theClass := (GsSession currentSession resolveSymbol: classString asSymbol)
		ifNotNil: [ :symbolAssoc | symbolAssoc value ].
	theClass ifNil: [ ^ self ].
	meta
		ifTrue: [ theClass := theClass class ].
	theClass new perform: selector withArguments: anArray.
	commandResultClass := (GsSession currentSession
		resolveSymbol: #'RowanCommandResult') value.
	^ commandResultClass results collect: [ :service | service makeSparkle ]
]
