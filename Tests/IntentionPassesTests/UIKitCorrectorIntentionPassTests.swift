import XCTest
import SwiftAST
import SwiftRewriterLib
import TestCommons
import IntentionPasses

class UIKitCorrectorIntentionPassTests: XCTestCase {
    func testDrawRect() {
        let inputSignature =
            FunctionSignature(name: "drawRect", parameters: [ParameterSignature(label: "_", name: "rect", type: .typeName("CGRect"))])
        let expectedSignature =
            FunctionSignature(name: "draw", parameters: [ParameterSignature(label: "_", name: "rect", type: .typeName("CGRect"))])
        
        assert(sut: UIKitCorrectorIntentionPass(),
               convertsSignature: inputSignature, into: expectedSignature,
               markAsOverride: true,
               onSubclassesOf: "UIView")
    }
}

extension UIKitCorrectorIntentionPassTests {
    func assert(sut: UIKitCorrectorIntentionPass, convertsSignature signature: FunctionSignature,
                into expected: FunctionSignature, markAsOverride: Bool, onSubclassesOf subclassOf: String,
                file: String = #file, line: Int = #line) {
        let format = { TypeFormatter.asString(signature: $0, includeName: true, includeFuncKeyword: true) }
        
        let intentions = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.inherit(from: subclassOf)
                    .createMethod(signature)
            }.build()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        let type = intentions.fileIntentions()[0].typeIntentions[0]
        let method = type.methods[0]
        let result = method.signature
        
        if result != expected {
            
            recordFailure(withDescription: """
                Expected to convert signature \(format(signature)) into \(format(expected)) \
                but converted to \(format(result))
                """
                , inFile: file, atLine: line, expected: true)
        }
        if markAsOverride && !method.isOverride {
            recordFailure(withDescription: "Expected to mark method \(format(result)) as override",
                          inFile: file, atLine: line, expected: true)
        }
    }
}
