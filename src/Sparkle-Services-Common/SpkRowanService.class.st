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
SpkRowanService >> blobPropertyNamed: symbol [

	^ (blob at: symbol) value
]

{ #category : 'accessing' }
SpkRowanService >> blobPropertyNamed: symbol ifAbsent: absentBlock [

	^ (blob at: symbol ifAbsent: absentBlock) value
]

{ #category : 'accessing' }
SpkRowanService >> rowanServiceClassName [

	^ rowanServiceClassName
]

{ #category : 'accessing' }
SpkRowanService >> rowanServiceClassName: anObject [

	rowanServiceClassName := anObject
]
