Class {
	#name : 'SpkRowanServiceClient',
	#superclass : 'SpkRowanService',
	#category : 'Sparkle-Services-Common'
}

{ #category : 'remote' }
SpkRowanServiceClient >> remotePerformOn: classString selector: aSelectorSymbol arguments: anArray [

	^(remoteSelf
		 remotePerformOn: classString
		 selector: aSelectorSymbol
		 arguments: anArray
		 meta: false) wait
]

{ #category : 'remote' }
SpkRowanServiceClient >> remotePerformOn: classString service: sparkleService selector: aSelectorSymbol arguments: anArray [

	^ (remoteSelf
		   remotePerformOn: classString
		   service: sparkleService
		   selector: aSelectorSymbol
		   arguments: anArray
		   meta: false) wait
]
