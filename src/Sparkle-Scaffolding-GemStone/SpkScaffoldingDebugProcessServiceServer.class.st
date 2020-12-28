Class {
	#name : 'SpkScaffoldingDebugProcessServiceServer',
	#superclass : 'SpkScaffoldingDebugProcessService',
	#instVars : [
		'suspendedProcess',
		'rowanProcessService'
	],
	#category : 'Sparkle-Scaffolding-GemStone'
}

{ #category : 'instance creation' }
SpkScaffoldingDebugProcessServiceServer class >> onSuspendedProcess: aSuspendedGsProcess [
	^ super new
		initializeOnSuspendedProcess: aSuspendedGsProcess;
		yourself
]

{ #category : 'initialization' }
SpkScaffoldingDebugProcessServiceServer >> initializeOnSuspendedProcess: aSuspendedGsProcess [
	"wil be using RowanProcessService>>servicePerform:withArguments: to send messages to the gsprocess"

	self suspendedProcess: aSuspendedGsProcess.
	self
		rowanProcessService:
			(RowanProcessService onSuspendedProcess: aSuspendedGsProcess).
	self
		suspendedProcessOop;
		rowanFrameServices	"prime the pump"
]

{ #category : 'debugging' }
SpkScaffoldingDebugProcessServiceServer >> resume [
	self suspendedProcess resume
]

{ #category : 'accessing' }
SpkScaffoldingDebugProcessServiceServer >> rowanFrameServices [
	^ rowanFrameServices
		ifNil: [ 
			rowanFrameServices := self rowanProcessService _frames
				collect: [ :frameService | SpkScaffoldingDebugFrameServiceServer new rowanFrameService: frameService ] ]
]

{ #category : 'accessing' }
SpkScaffoldingDebugProcessServiceServer >> rowanProcessService [
	^ rowanProcessService
]

{ #category : 'accessing' }
SpkScaffoldingDebugProcessServiceServer >> rowanProcessService: object [
	rowanProcessService := object
]

{ #category : 'accessing' }
SpkScaffoldingDebugProcessServiceServer >> suspendedProcess [
	^suspendedProcess
]

{ #category : 'accessing' }
SpkScaffoldingDebugProcessServiceServer >> suspendedProcess: object [
	suspendedProcess := object
]

{ #category : 'accessing' }
SpkScaffoldingDebugProcessServiceServer >> suspendedProcessName [
	^ self suspendedProcess name isEmpty
		ifTrue: [ 'GsProcess [' , self suspendedProcessOop asString , ']' ]
]

{ #category : 'suspended process' }
SpkScaffoldingDebugProcessServiceServer >> suspendedProcessOop [
	^ suspendedProcessOop
		ifNil: [ suspendedProcessOop := self rowanProcessService oop ]
]