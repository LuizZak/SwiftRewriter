import XCTest
import IntentionPasses
import TestCommons
import SwiftRewriterLib
import SwiftAST

class DropNSFromTypesIntentionPassTests: XCTestCase {
    func testConvertGlobalVariable() {
        let intentions
            = IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createGlobalVariable(withName: "a", type: .typeName("NSDate"))
                }.build()
        let sut = DropNSFromTypesIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(intentions.globalVariables()[0].type, .typeName("Date"))
    }
    
    func testConvertGlobalFunction() {
        let intentions
            = IntentionCollectionBuilder()
                .createFile(named: "A") { file in
                    file.createGlobalFunction(withSignature:
                        FunctionSignature(name: "a",
                                          parameters: [ParameterSignature(label: "_", name: "a", type: .typeName("NSDate"))],
                                          returnType: .typeName("NSDate"),
                                          isStatic: false))
                }.build()
        let sut = DropNSFromTypesIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(intentions.globalFunctions()[0].signature.returnType, .typeName("Date"))
        XCTAssertEqual(intentions.globalFunctions()[0].signature.parameters[0].type, .typeName("Date"))
    }
    
    func testConvertProperty() {
        let intentions
            = IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createProperty(named: "a", type: .typeName("NSDate"))
                }.build()
        let sut = DropNSFromTypesIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(intentions.typeIntentions()[0].properties[0].type, .typeName("Date"))
    }
    
    func testConvertMethod() {
        let intentions
            = IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createMethod(
                        FunctionSignature(name: "a",
                                          parameters: [ParameterSignature(label: "_", name: "a", type: .typeName("NSDate"))],
                                          returnType: .typeName("NSDate"),
                                          isStatic: false))
                }.build()
        let sut = DropNSFromTypesIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(intentions.typeIntentions()[0].methods[0].returnType, .typeName("Date"))
        XCTAssertEqual(intentions.typeIntentions()[0].methods[0].parameters[0].type, .typeName("Date"))
    }
    
    func testConvertConstructor() {
        let intentions
            = IntentionCollectionBuilder()
                .createFileWithClass(named: "A") { builder in
                    builder.createConstructor(withParameters: [ParameterSignature(label: "_", name: "a", type: .typeName("NSDate"))])
                }.build()
        let sut = DropNSFromTypesIntentionPass()
        
        sut.apply(on: intentions, context: makeContext(intentions: intentions))
        
        XCTAssertEqual(intentions.typeIntentions()[0].constructors[0].parameters[0].type, .typeName("Date"))
    }
}
