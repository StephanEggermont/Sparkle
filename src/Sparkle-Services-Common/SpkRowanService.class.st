Class {
	#name : 'SpkRowanService',
	#superclass : 'RsrService',
	#instVars : [
		'rowanServiceClassName',
		'blob'
	],
	#category : 'Sparkle-Services-Common'
}

{ #category : 'accessing' }
SpkRowanService class >> templateClassName [

	^ #SpkRowanService
]

{ #category : 'accessing' }
SpkRowanService >> blob [

	^ blob
]

{ #category : 'accessing' }
SpkRowanService >> blob: anObject [

	blob := anObject
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

{ #category : 'accessing' }
SpkRowanService >> rowanServiceClassName [

	^ rowanServiceClassName
]

{ #category : 'accessing' }
SpkRowanService >> rowanServiceClassName: anObject [

	rowanServiceClassName := anObject
]
