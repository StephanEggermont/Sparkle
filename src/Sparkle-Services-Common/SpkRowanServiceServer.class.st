Class {
	#name : 'SpkRowanServiceServer',
	#superclass : 'SpkRowanService',
	#category : 'Sparkle-Services-Common'
}

{ #category : 'command execution' }
SpkRowanServiceServer >> remotePerformOn: classString selector: selector arguments: anArray meta: meta [
        | theClass commandResultClass sparkleServices |
        theClass := (GsSession currentSession resolveSymbol: classString asSymbol)
                ifNil: [ ^ self ]
                ifNotNil: [ :symbolAssoc | symbolAssoc value ].
        commandResultClass := (GsSession currentSession
                resolveSymbol: #'RowanCommandResult') value.
        commandResultClass initializeResults.
        meta
                ifTrue: [ theClass := theClass class ].
        theClass new perform: selector withArguments: anArray.
        sparkleServices := commandResultClass results
                collect: [ :service | service makeSparkle ].
        ^ sparkleServices

]
