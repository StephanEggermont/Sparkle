Class {
	#name : 'SpkRowanServiceClient',
	#superclass : 'SpkRowanService',
	#category : 'Sparkle-Services-Common'
}

{ #category : 'remote' }
SpkRowanServiceClient >> remotePerformOn: classString selector: aSelectorSymbol arguments: anArray [

	(remoteSelf
		 remotePerformOn: classString
		 selector: aSelectorSymbol
		 arguments: anArray
		 meta: false) wait
]
