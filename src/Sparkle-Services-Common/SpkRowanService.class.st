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

{ #category : 'comparing' }
SpkRowanService >> = anObject [

	"Need implementation in Object"

	(self isKindOf: self class) ifTrue: [ 
		^ (self blobPropertyNamed: #oop)
		  = (anObject blobPropertyNamed: #oop) and: [ 
			  (self blobPropertyNamed: #meta)
			  = (anObject blobPropertyNamed: #meta) ] ].
	^ false
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
SpkRowanService >> blobPropertyNamed: symbol [

	^ (blob at: symbol) value
]

{ #category : 'accessing' }
SpkRowanService >> blobPropertyNamed: symbol ifAbsent: absentBlock [

	^ (blob at: symbol ifAbsent: absentBlock) value
]

{ #category : 'accessing' }
SpkRowanService >> blobPropertyNamed: symbol put: value [

	^ blob at: symbol put: value
]

{ #category : 'comparing' }
SpkRowanService >> hash [

	^ self blobPropertyNamed: #oop
]

{ #category : 'accessing' }
SpkRowanService >> rowanServiceClassName [

	^ rowanServiceClassName
]

{ #category : 'accessing' }
SpkRowanService >> rowanServiceClassName: anObject [

	rowanServiceClassName := anObject
]
