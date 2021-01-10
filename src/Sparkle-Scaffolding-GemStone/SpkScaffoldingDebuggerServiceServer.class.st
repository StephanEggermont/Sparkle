Class {
	#name : 'SpkScaffoldingDebuggerServiceServer',
	#superclass : 'SpkScaffoldingDebuggerService',
	#instVars : [
		'resumptionValue'
	],
	#category : 'Sparkle-Scaffolding-GemStone'
}

{ #category : 'debugger' }
SpkScaffoldingDebuggerServiceServer >> clearAllBreaks [
	"clear all breakpoints set in image"

	GsNMethod clearAllBreaks
]

{ #category : 'debugger' }
SpkScaffoldingDebuggerServiceServer >> openDebuggerOnClient [
	^ remoteSelf openDebuggerOnClient
]

{ #category : 'debugger' }
SpkScaffoldingDebuggerServiceServer >> openDebuggerOnClientForProcess: aSuspendedGsProcess exception: ex [
	self
		processService:
			((SpkScaffoldingDebugProcessServiceServer
				onSuspendedProcess: aSuspendedGsProcess)
				doitException: ex;
				debuggerService: self;
				yourself).
	^ self openDebuggerOnClient wait
]

{ #category : 'debugger' }
SpkScaffoldingDebuggerServiceServer >> resumptionValue [
	^ resumptionValue
]

{ #category : 'debugger' }
SpkScaffoldingDebuggerServiceServer >> resumptionValue: anObject [
	"Note that if nil is used, then the exception will resume with object that is on the top of the stack"

	resumptionValue := anObject
]

{ #category : 'debugger' }
SpkScaffoldingDebuggerServiceServer >> setBreakpointForClass: className meta: isMeta selector: selector atStepPoint: stepPoint [
	"Set a breakpoint that will be signalled to the GCI.
		Returns true to indicate success.  Otherwise returns a string describing the error."

	| beh res |
	beh := Rowan globalNamed: className.
	isMeta
		ifTrue: [ beh := beh class ].
	res := beh
		_setMethodBreak: selector
		stepPoint: stepPoint
		env: 0
		pType: 1.
	^ res
]