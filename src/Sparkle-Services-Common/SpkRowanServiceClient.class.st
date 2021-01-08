Class {
	#name : 'SpkRowanServiceClient',
	#superclass : 'SpkRowanService',
	#category : 'Sparkle-Services-Common'
}

{ #category : 'accessing' }
SpkRowanServiceClient >> blobPropertyNamed: symbol [

	^ (blob at: symbol) value
]

{ #category : 'remote' }
SpkRowanServiceClient >> remotePerformOn: classString selector: aSelectorSymbol arguments: anArray [

	^(remoteSelf
		 remotePerformOn: classString
		 selector: aSelectorSymbol
		 arguments: anArray
		 meta: false) wait
]
