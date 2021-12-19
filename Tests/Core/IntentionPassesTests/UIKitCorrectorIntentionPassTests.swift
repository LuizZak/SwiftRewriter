import XCTest
import SwiftAST
import KnownType
import Intentions
import SwiftRewriterLib
import TestCommons

@testable import IntentionPasses

class UIKitCorrectorIntentionPassTests: XCTestCase {
    func testDrawRect() {
        let inputSignature =
            FunctionSignature(
                name: "drawRect",
                parameters: [
                    ParameterSignature(label: nil,
                                       name: "rect",
                                       type: "CGRect")
                ])
        
        let expectedSignature =
            FunctionSignature(
                name: "draw",
                parameters: [
                    ParameterSignature(label: nil,
                                       name: "rect",
                                       type: "CGRect")
                ])
        
        assert(sut: UIKitCorrectorIntentionPass(),
               convertsSignature: inputSignature, into: expectedSignature,
               markAsOverride: true,
               onSubclassesOf: "UIView")
    }
    
    func testUpdatesNullabilityOfDetectedOverrides() {
        let inputSignature =
            FunctionSignature(
                name: "convertPoint",
                parameters: [
                    ParameterSignature(label: nil,
                                       name: "point",
                                       type: "CGPoint"),
                    
                    ParameterSignature(label: "toView",
                                       name: "view",
                                       type: .implicitUnwrappedOptional("UIView"))
                ],
                returnType: "CGPoint")
        
        let expectedSignature =
            FunctionSignature(
                name: "convert",
                parameters: [
                    ParameterSignature(label: nil,
                                       name: "point",
                                       type: "CGPoint"),
                    
                    ParameterSignature(label: "to",
                                       name: "view",
                                       type: .optional("UIView"))
                ],
                returnType: "CGPoint")
        
        assert(sut: UIKitCorrectorIntentionPass(),
               convertsSignature: inputSignature,
               into: expectedSignature,
               markAsOverride: true,
               onSubclassesOf: "UIView")
    }
    
    func testUITableViewDelegate() {
        let inputSignature =
            FunctionSignature(name: "tableView", parameters: [
                ParameterSignature(label: nil, name: "tableView", type: "UITableView"),
                ParameterSignature(label: "willDisplayCell", name: "cell", type: "UITableViewCell"),
                ParameterSignature(label: "forRowAtIndexPath", name: "indexPath", type: "IndexPath")
            ])
        let expectedSignature =
            FunctionSignature(name: "tableView", parameters: [
                ParameterSignature(label: nil, name: "tableView", type: "UITableView"),
                ParameterSignature(label: "willDisplay", name: "cell", type: "UITableViewCell"),
                ParameterSignature(label: "forRowAt", name: "indexPath", type: "IndexPath")
            ])
        
        assert(sut: UIKitCorrectorIntentionPass(),
               convertsSignature: inputSignature, into: expectedSignature,
               onImplementersOfProtocol: "UITableViewDelegate")
    }
    
    func testUITableViewDataSource() {
        let inputSignature =
            FunctionSignature(name: "tableView", parameters: [
                ParameterSignature(label: nil, name: "tableView", type: "UITableView"),
                ParameterSignature(label: "cellForRowAtIndexPath", name: "indexPath", type: "IndexPath"),
            ])
        let expectedSignature =
            FunctionSignature(name: "tableView", parameters: [
                ParameterSignature(label: nil, name: "tableView", type: "UITableView"),
                ParameterSignature(label: "cellForRowAt", name: "indexPath", type: "IndexPath")
            ])
        
        assert(sut: UIKitCorrectorIntentionPass(),
               convertsSignature: inputSignature, into: expectedSignature,
               onImplementersOfProtocol: "UITableViewDataSource")
    }
}

extension UIKitCorrectorIntentionPassTests {
    fileprivate func assertSignature(_ intentions: IntentionCollection,
                                     _ expected: FunctionSignature,
                                     _ signature: FunctionSignature,
                                     _ markAsOverride: Bool,
                                     _ file: StaticString, _ line: UInt) {
        
        let format = { TypeFormatter.asString(signature: $0, includeName: true, includeFuncKeyword: true) }
        let type = intentions.fileIntentions()[0].typeIntentions[0]
        let method = type.methods[0]
        let result = method.signature
        
        if result != expected {
            XCTFail("""
                    Expected to convert signature
                    \(format(signature))
                    into
                    \(format(expected))
                    but converted to
                    \(format(result))
                    """,
                    file: file, line: line)
        }
        if markAsOverride && !method.isOverride {
            XCTFail("Expected to mark method \(format(result)) as override",
                    file: file, line: line)
        }
    }
    
    func assert(sut: UIKitCorrectorIntentionPass,
                convertsSignature signature: FunctionSignature,
                into expected: FunctionSignature,
                markAsOverride: Bool,
                onSubclassesOf subclassOf: String,
                file: StaticString = #file, line: UInt = #line) {
        
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.inherit(from: subclassOf)
                    .createMethod(signature)
            }.build()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        assertSignature(intentions, expected, signature, markAsOverride, file, line)
    }
    
    func assert(sut: UIKitCorrectorIntentionPass,
                convertsSignature signature: FunctionSignature,
                into expected: FunctionSignature,
                onImplementersOfProtocol protocolName: String,
                file: StaticString = #file, line: UInt = #line) {
        
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createConformance(protocolName: protocolName)
                    .createMethod(signature)
            }.build()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        assertSignature(intentions, expected, signature, false, file, line)
    }
}
