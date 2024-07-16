//
//  SBObjectProtocol.swift
//  Swoop
//
//  Created by Leo Dion on 7/16/24.
//


import AppKit
import ScriptingBridge

@objc public protocol SBObjectProtocol: NSObjectProtocol {
  func get() -> Any!
}


@objc public protocol SBApplicationProtocol: SBObjectProtocol {
  func activate()
  var delegate: SBApplicationDelegate! { get set }
  //var running: Bool { @objc(isRunning) get }
}

// Define the protocols with @objc and optional methods/properties
@objc protocol XcodeGenericMethods: AnyObject, SBObjectProtocol {
    @objc optional func closeSaving(_ saving: XcodeSaveOptions, savingIn: URL?)
    @objc optional func delete()
    @objc optional func moveTo(_ to: SBObject)
    @objc optional func build() -> XcodeSchemeActionResult
    @objc optional func clean() -> XcodeSchemeActionResult
    @objc optional func stop()
    @objc optional func run(withCommandLineArguments: Any, withEnvironmentVariables: Any) -> XcodeSchemeActionResult
    @objc optional func test(withCommandLineArguments: Any, withEnvironmentVariables: Any) -> XcodeSchemeActionResult
    @objc optional func attachToProcessIdentifier(_ toProcessIdentifier: Int, suspended: Bool)
    @objc optional func debugScheme(_ scheme: String, runDestinationSpecifier: String, skipBuilding: Bool, commandLineArguments: Any, environmentVariables: Any) -> XcodeSchemeActionResult
}

@objc protocol XcodeApplication: SBApplicationProtocol, XcodeGenericMethods {
    @objc optional var documents: SBElementArray { get }
    @objc optional var windows: SBElementArray { get }
    @objc optional var name: String { get }
    @objc optional var frontmost: Bool { get }
    @objc optional var version: String { get }
    
    @objc optional func open(_ x: Any) -> Any
    @objc optional func quitSaving(_ saving: XcodeSaveOptions)
    @objc optional func exists(_ x: Any) -> Bool
    @objc optional func createTemporaryDebuggingWorkspace() -> XcodeWorkspaceDocument
}


@objc protocol XcodeDocument: XcodeGenericMethods, SBObjectProtocol {
    @objc optional var name: String { get }
    @objc optional var modified: Bool { get }
    @objc optional var file: URL { get }
}

@objc protocol XcodeWindow: XcodeGenericMethods {
    @objc optional var name: String { get }
    @objc optional var id: Int { get }
    @objc optional var index: Int { get set }
    @objc optional var bounds: NSRect { get set }
    @objc optional var closeable: Bool { get }
    @objc optional var miniaturizable: Bool { get }
    @objc optional var miniaturized: Bool { get set }
    @objc optional var resizable: Bool { get }
    @objc optional var visible: Bool { get set }
    @objc optional var zoomable: Bool { get }
    @objc optional var zoomed: Bool { get set }
    @objc optional var document: XcodeDocument { get }
}

@objc protocol XcodeApplicationSuite: XcodeApplication {
    @objc optional var fileDocuments: SBElementArray { get }
    @objc optional var sourceDocuments: SBElementArray { get }
    @objc optional var workspaceDocuments: SBElementArray { get }
    @objc optional var activeWorkspaceDocument: XcodeWorkspaceDocument { get set }
}

@objc protocol XcodeDocumentSuite: XcodeDocument {
    @objc optional var path: String { get set }
}

@objc protocol XcodeFileDocument: XcodeDocumentSuite {}

@objc protocol XcodeTextDocument: XcodeFileDocument {
    @objc optional var selectedCharacterRange: [NSNumber] { get set }
    @objc optional var selectedParagraphRange: [NSNumber] { get set }
    @objc optional var text: String { get set }
    @objc optional var notifiesWhenClosing: Bool { get set }
}

@objc protocol XcodeSourceDocument: XcodeTextDocument {}

@objc protocol XcodeWorkspaceDocument: XcodeDocument, SBObjectProtocol {
    @objc optional var projects: SBElementArray { get }
    @objc optional var schemes: SBElementArray { get }
    @objc optional var runDestinations: SBElementArray { get }
    @objc optional var loaded: Bool { get set }
    @objc optional var activeScheme: XcodeScheme { get set }
    @objc optional var activeRunDestination: XcodeRunDestination { get set }
    @objc optional var lastSchemeActionResult: XcodeSchemeActionResult { get set }
    @objc optional var file: URL { get }
}

@objc protocol XcodeSchemeActionResult: XcodeGenericMethods {
    @objc optional var buildErrors: SBElementArray { get }
    @objc optional var buildWarnings: SBElementArray { get }
    @objc optional var analyzerIssues: SBElementArray { get }
    @objc optional var testFailures: SBElementArray { get }
    @objc optional var id: String { get }
    @objc optional var completed: Bool { get }
    @objc optional var status: XcodeSchemeActionResultStatus { get set }
    @objc optional var errorMessage: String { get set }
    @objc optional var buildLog: String { get set }
}

@objc protocol XcodeSchemeActionIssue: XcodeGenericMethods {
    @objc optional var message: String { get set }
    @objc optional var filePath: String { get set }
    @objc optional var startingLineNumber: Int { get set }
    @objc optional var endingLineNumber: Int { get set }
    @objc optional var startingColumnNumber: Int { get set }
    @objc optional var endingColumnNumber: Int { get set }
}

@objc protocol XcodeBuildError: XcodeSchemeActionIssue {}

@objc protocol XcodeBuildWarning: XcodeSchemeActionIssue {}

@objc protocol XcodeAnalyzerIssue: XcodeSchemeActionIssue {}

@objc protocol XcodeTestFailure: XcodeSchemeActionIssue {}

@objc protocol XcodeScheme: XcodeGenericMethods {
    @objc optional var name: String { get }
    @objc optional var id: String { get }
}

@objc protocol XcodeRunDestination: XcodeGenericMethods {
    @objc optional var name: String { get }
    @objc optional var architecture: String { get }
    @objc optional var platform: String { get }
    @objc optional var device: XcodeDevice { get }
    @objc optional var companionDevice: XcodeDevice { get }
}

@objc protocol XcodeDevice: XcodeGenericMethods {
    @objc optional var name: String { get }
    @objc optional var deviceIdentifier: String { get }
    @objc optional var operatingSystemVersion: String { get }
    @objc optional var deviceModel: String { get }
    @objc optional var generic: Bool { get }
}

@objc protocol XcodeBuildConfiguration: XcodeGenericMethods {
    @objc optional var buildSettings: SBElementArray { get }
    @objc optional var resolvedBuildSettings: SBElementArray { get }
    @objc optional var id: String { get }
    @objc optional var name: String { get }
}

@objc protocol XcodeProject: XcodeGenericMethods {
    @objc optional var buildConfigurations: SBElementArray { get }
    @objc optional var targets: SBElementArray { get }
    @objc optional var name: String { get }
    @objc optional var id: String { get }
}

@objc protocol XcodeBuildSetting: XcodeGenericMethods {
    @objc optional var name: String { get set }
    @objc optional var value: String { get set }
}

@objc protocol XcodeResolvedBuildSetting: XcodeGenericMethods {
    @objc optional var name: String { get set }
    @objc optional var value: String { get set }
}

@objc protocol XcodeTarget: XcodeGenericMethods {
    @objc optional var buildConfigurations: SBElementArray { get }
    @objc optional var name: String { get set }
    @objc optional var id: String { get }
    @objc optional var project: XcodeProject { get }
}

@objc enum XcodeSaveOptions: Int {
    case yes // = 'yes ' // Save the file.
    case no // = 'no  ' // Do not save the file.
    case ask // = 'ask ' // Ask the user whether or not to save the file.
}

@objc enum XcodeSchemeActionResultStatus: Int {
    case notYetStarted // = 'srsn' // The action has not yet started.
    case running // = 'srsr' // The action is in progress.
    case cancelled // = 'srsc' // The action was cancelled.
    case failed // = 'srsf' // The action ran but did not complete successfully.
    case errorOccurred // = 'srse' // The action was not able to run due to an error.
    case succeeded // = 'srss' // The action succeeded.
}

// Extend SBObject and SBApplication to conform to the protocols

extension SBObject: XcodeGenericMethods {}

extension SBApplication: XcodeApplication {}

// Similarly, you can extend SBObject for other protocols

// Example for XcodeDocument
extension SBObject: XcodeDocument {}

extension SBObject: XcodeWorkspaceDocument {}

extension SBObject : XcodeRunDestination {}
// Continue this pattern for the rest of the protocols
