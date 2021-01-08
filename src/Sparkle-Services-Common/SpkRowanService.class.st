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

{ #category : 'accessing' }
SpkRowanService >> rowanServiceClassName [

	^ rowanServiceClassName
]

{ #category : 'accessing' }
SpkRowanService >> rowanServiceClassName: anObject [

	rowanServiceClassName := anObject
]
