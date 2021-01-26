Class {
	#name : 'SpkRowanServiceClient',
	#superclass : 'SpkRowanService',
	#instVars : [
		'announcer'
	],
	#category : 'Sparkle-Services-Common'
}

{ #category : 'accessing' }
SpkRowanServiceClient >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'accessing' }
SpkRowanServiceClient >> meta [ 

	^(self blobPropertyNamed: #meta)
]

{ #category : 'accessing' }
SpkRowanServiceClient >> oop [

	^ self blobPropertyNamed: #oop
]

{ #category : 'remote' }
SpkRowanServiceClient >> remotePerformOn: classString selector: aSelectorSymbol arguments: anArray [

	^(remoteSelf
		 remotePerformOn: classString
		 selector: aSelectorSymbol
		 arguments: anArray
		 meta: false) wait
]

{ #category : 'remote' }
SpkRowanServiceClient >> remotePerformOnService: sparkleService selector: aSelectorSymbol arguments: anArray [

	^ (remoteSelf
		   remotePerformOnService: sparkleService
		   selector: aSelectorSymbol
		   arguments: anArray) wait
]
