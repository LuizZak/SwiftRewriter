import XCTest
import GrammarModels
import ObjcParser
import ObjcParserAntlr
import SwiftAST
import KnownType
import Intentions
import SwiftRewriterLib
import TypeSystem
import ObjectiveCFrontend

@testable import IntentionPasses

class SwiftifyMethodSignaturesIntentionPassTests: XCTestCase {
    func testConvertWith() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWithColor",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "color", type: .typeName("CGColor"))
                    ]))
            .converts(to:
                FunctionSignature(name: "doThing",
                                  parameters: [
                                    ParameterSignature(label: "with", name: "color", type: .typeName("CGColor"))
                    ]))
    }
    
    func testConvertWithOnlyConvertsIfSelectorSuffixMatchesTypeNameAsWell() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWithColor",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "color", type: .int)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThingWithColor",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "color", type: .int)
                    ]))
    }
    
    func testConvertWithAtSuffix() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWith",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "color", type: .any)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThingWith",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "color", type: .any)
                    ]))
    }
    
    func testConvertWithin() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWithin",
                                  parameters: []))
            .converts(to:
                FunctionSignature(name: "doThingWithin",
                                  parameters: []))
    }
    
    func testConvertWithinWithParameter() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWithin",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "thing", type: .any)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThingWithin",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "thing", type: .any)
                    ]))
    }
    
    func testConvertInit() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "init",
                                  parameters: [],
                                  returnType: .anyObject,
                                  isStatic: false))
            .converts(toInitializer: [])
    }
    
    func testConvertInitWithInt() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "initWithInt",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "int", type: .int)],
                                  returnType: .anyObject,
                                  isStatic: false))
            .converts(toInitializer: [
                ParameterSignature(label: "int", name: "int", type: .int)
            ])
    }
    
    func testConvertVeryShortTypeName() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "initWithB",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "b", type: .typeName("B"))],
                                  returnType: .instancetype,
                                  isStatic: false))
            .converts(toInitializer: [
                ParameterSignature(label: "b", name: "b", type: .typeName("B"))
            ])
    }
    
    func testConvertInitWithNonMatchingSelectorName() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "initWithObjectList",
                                  parameters: [
                                    ParameterSignature(label: nil, name: "objects", type: .array(.typeName("Object")))
                                  ],
                                  returnType: .instancetype,
                                  isStatic: false))
            .converts(toInitializer: [ParameterSignature(label: "objectList", name: "objects", type: .array(.typeName("Object")))])
    }
    
    func testDontConvertNonInitMethods() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(typeName: "Squeak", sut: sut)
            .method(withObjcSignature: "- (Squeak*)getSqueakWithID:(NSInteger)id;")
            .converts(to: FunctionSignature(name: "getSqueakWithID",
                                            parameters: [ParameterSignature(label: nil, name: "id", type: .int)],
                                            returnType: .nullabilityUnspecified(.typeName("Squeak")),
                                            isStatic: false))
    }
    
    func testConvertNullableReturnInitsIntoFailableInits() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(typeName: "Squeak", sut: sut)
            .method(withSignature: FunctionSignature(name: "initWithValue",
                                                     parameters: [ParameterSignature(label: nil, name: "value", type: .int)],
                                                     returnType: .optional(.typeName("Squeak")),
                                                     isStatic: false))
            .converts(toInitializer: "init?(value: Int)")
    }
}

private extension SwiftifyMethodSignaturesIntentionPassTests {
    func testThat(typeName: String = "T", sut: SwiftifyMethodSignaturesIntentionPass) -> SwiftifyMethodSignaturesIntentionPassTestBuilder {
        return
            SwiftifyMethodSignaturesIntentionPassTestBuilder(
                testCase: self,
                typeName: typeName,
                sut: sut
        )
    }
}

private class SwiftifyMethodSignaturesIntentionPassTestBuilder {
    let testCase: XCTestCase
    let intentions: IntentionCollection
    let type: TypeGenerationIntention
    let sut: SwiftifyMethodSignaturesIntentionPass
    
    init(testCase: XCTestCase, typeName: String = "T", sut: SwiftifyMethodSignaturesIntentionPass) {
        self.testCase = testCase
        self.sut = sut
        intentions = IntentionCollection()
        
        type = TypeGenerationIntention(typeName: typeName)
        let file = FileGenerationIntention(sourcePath: "", targetPath: "")
        file.addType(type)
        intentions.addIntention(file)
    }
    
    func method(withObjcSignature signature: String) -> Asserter {
        let def = parseMethodSign(signature)
        let sign = createSwiftMethodSignatureGen().generateDefinitionSignature(from: def)
        
        return method(withSignature: sign)
    }
    
    func method(withSignature signature: FunctionSignature) -> Asserter {
        type.addMethod(MethodGenerationIntention(signature: signature))
        
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentions)
        let invoker = DefaultTypeResolverInvoker(globals: ArrayDefinitionsSource(),
                                                 typeSystem: typeSystem,
                                                 numThreads: 8)
        let mapper = DefaultTypeMapper(typeSystem: typeSystem)
        let context = IntentionPassContext(typeSystem: TypeSystem.defaultTypeSystem,
                                           typeMapper: mapper,
                                           typeResolverInvoker: invoker,
                                           numThreads: 8)
        
        sut.apply(on: intentions, context: context)
        
        return Asserter(testCase: testCase, intentions: intentions, type: type)
    }
    
    private func createSwiftMethodSignatureGen() -> ObjectiveCMethodSignatureConverter {
        let mapper = DefaultTypeMapper(typeSystem: IntentionCollectionTypeSystem(intentions: intentions))
        
        return ObjectiveCMethodSignatureConverter(typeMapper: mapper, inNonnullContext: false)
    }
    
    private func parseMethodSign(_ source: String) -> MethodDefinition {
        let finalSrc = """
        @interface myClass
        \(source)
        @end
        """
        
        let parser = ObjcParser(string: finalSrc)
        
        try! parser.parse()
        
        let node =
            parser.rootNode
                .firstChild(ofType: ObjcClassInterface.self)?
                .firstChild(ofType: MethodDefinition.self)
        return node!
    }
    
    class Asserter {
        let testCase: XCTestCase
        let intentions: IntentionCollection
        let type: TypeGenerationIntention
        let typeMapper: TypeMapper
        
        init(testCase: XCTestCase, intentions: IntentionCollection, type: TypeGenerationIntention) {
            self.testCase = testCase
            self.intentions = intentions
            self.type = type
            self.typeMapper = DefaultTypeMapper(typeSystem: IntentionCollectionTypeSystem(intentions: intentions))
        }
        
        func converts(toInitializer parameters: [ParameterSignature], file: StaticString = #filePath, line: UInt = #line) {
            guard let ctor = type.constructors.first else {
                XCTFail("""
                        Failed to generate initializer: No initializers where found \
                        on target type.
                        Found these methods instead:
                        \(dumpType())
                        """,
                        file: file, line: line)
                return
            }
            guard ctor.parameters != parameters else {
                return
            }
            
            XCTFail("""
                    Expected to generate constructor with parameters \(parameters),
                    but converted to \(ctor.parameters)
                    """,
                    file: file, line: line)
        }
        
        func converts(toInitializer expected: String, file: StaticString = #filePath, line: UInt = #line) {
            guard let ctor = type.constructors.first else {
                XCTFail("""
                        Failed to generate initializer: No initializers where found \
                        on target type.
                        Found these methods instead:
                        \(dumpType())
                        """,
                        file: file, line: line)
                return
            }
            
            let result = TypeFormatter.asString(initializer: ctor)
            
            guard result != expected else {
                return
            }
            
            XCTFail("""
                    Expected to generate constructor with parameters \(expected),
                    but converted to \(result)
                    """,
                    file: file, line: line)
        }
        
        func converts(to signature: FunctionSignature, file: StaticString = #filePath, line: UInt = #line) {
            guard let method = type.methods.first else {
                XCTFail("""
                        Failed to generate method: No methods where found on \
                        target type.
                        Found these methods instead:
                        \(dumpType())
                        """,
                        file: file, line: line)
                return
            }
            
            guard method.signature != signature else {
                return
            }
            
            XCTFail("""
                    Expected signature \(TypeFormatter.asString(signature: signature, includeName: true)), \
                    but converted to \(TypeFormatter.asString(signature: method.signature, includeName: true))
                    """,
                    file: file, line: line)
        }
        
        func converts(to signature: String, file: StaticString = #filePath, line: UInt = #line) {
            guard let method = type.methods.first else {
                XCTFail("""
                        Failed to generate method: No methods where found on \
                        target type.
                        Found these methods instead:
                        \(dumpType())
                        """,
                        file: file, line: line)
                return
            }
            
            let converted = TypeFormatter.asString(signature: method.signature, includeName: true)
            guard converted != signature else {
                return
            }
            
            XCTFail("""
                    Expected signature \(signature), but converted to \(converted)
                    """,
                    file: file, line: line)
        }
        
        func dumpType() -> String {
            var dump = ""
            
            if !type.constructors.isEmpty {
                dump += "Initializers:\n"
                
                for ctor in type.constructors {
                    dump += "init\(TypeFormatter.asString(parameters: ctor.parameters))\n"
                }
            }
            
            if !type.methods.isEmpty {
                dump += "Methods:\n"
                
                for method in type.methods {
                    dump += "Method: \(TypeFormatter.asString(signature: method.signature, includeName: true))"
                    dump += "\n"
                }
            }
            
            return dump
        }
    }
}
