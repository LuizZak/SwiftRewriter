//
//  SwiftifyMethodSignaturesIntentionPassTests.swift
//  SwiftRewriterLibTests
//
//  Created by Luiz Fernando Silva on 24/02/2018.
//

import XCTest
import GrammarModels
import ObjcParser
import ObjcParserAntlr
import SwiftAST
import IntentionPasses
import SwiftRewriterLib

class SwiftifyMethodSignaturesIntentionPassTests: XCTestCase {
    func testConvertWith() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWithColor",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "color", type: .typeName("CGColor"))
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
                                    ParameterSignature(label: "_", name: "color", type: .int)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThingWithColor",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "color", type: .int)
                    ]))
    }
    
    func testConvertWithAtSuffix() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(sut: sut)
            .method(withSignature:
                FunctionSignature(name: "doThingWith",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "color", type: .any)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThingWith",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "color", type: .any)
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
                                    ParameterSignature(label: "_", name: "thing", type: .any)
                    ]))
            .converts(to:
                FunctionSignature(name: "doThingWithin",
                                  parameters: [
                                    ParameterSignature(label: "_", name: "thing", type: .any)
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
                                    ParameterSignature(label: "_", name: "int", type: .int)],
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
                                    ParameterSignature(label: "_", name: "b", type: .typeName("B"))],
                                  returnType: .instancetype,
                                  isStatic: false))
            .converts(toInitializer: [
                ParameterSignature(label: "b", name: "b", type: .typeName("B"))
                ])
    }
    
    /// Tests automatic swiftification of `[NSTypeName typeNameWithThing:<x>]`-style
    /// initializers.
    /// This helps test mimicing of Swift's importer behavior.
    func testSwiftifyStaticFactoryMethods() {
        let sut = SwiftifyMethodSignaturesIntentionPass()
        
        testThat(typeName: "NSNumber", sut: sut)
            .method(withObjcSignature: "+ (NSNumber*)numberWithBool:(BOOL)bool;")
            .converts(toInitializer: "init(bool: Bool)")
        
        testThat(typeName: "NSNumber", sut: sut)
            .method(withObjcSignature: "+ (NSNumber*)numberWithInteger:(NSInteger)integer;")
            .converts(toInitializer: "init(integer: Int)")
        
        testThat(typeName: "UIAlertController", sut: sut)
            .method(withObjcSignature: """
                + (instancetype)alertControllerWithTitle:(nullable NSString *)title
                                                 message:(nullable NSString *)message
                                          preferredStyle:(UIAlertControllerStyle)preferredStyle;
                """)
            .converts(toInitializer: "init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle)")
        
        testThat(typeName: "UIButton", sut: sut)
            .method(withObjcSignature: "+ (instancetype)buttonWithType:(UIButtonType)buttonType;")
            .converts(toInitializer: "init(type buttonType: UIButtonType)")
        
        testThat(typeName: "UIColor", sut: sut)
            .method(withObjcSignature: "+ (UIColor *)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha;")
            .converts(toInitializer: "init(white: CGFloat, alpha: CGFloat)")
        
        testThat(typeName: "UIColor", sut: sut)
            .method(withObjcSignature: "+ (UIColor *)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;")
            .converts(toInitializer: "init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)")
        
        /* TODO: Make this pass
        testThat(typeName: "UIImage", sut: sut)
            .method(withObjcSignature: "+ (nullable UIImage *)imageNamed:(NSString *)name;")
            .converts(toInitializer: "init(named name: String!)")
        */
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
        
        let resolver = ExpressionTypeResolver(typeSystem: DefaultTypeSystem())
        let invoker = DefaultTypeResolverInvoker(typeResolver: resolver)
        let ctx = TypeConstructionContext(typeSystem: IntentionCollectionTypeSystem(intentions: intentions))
        let mapper = DefaultTypeMapper(context: ctx)
        let context =
            IntentionPassContext(typeSystem: DefaultTypeSystem(),
                                 typeMapper: mapper,
                                 typeResolverInvoker: invoker)
        
        sut.apply(on: intentions, context: context)
        
        return Asserter(testCase: testCase, intentions: intentions, type: type)
    }
    
    private func createSwiftMethodSignatureGen() -> SwiftMethodSignatureGen {
        let ctx = TypeConstructionContext(typeSystem: IntentionCollectionTypeSystem(intentions: intentions))
        let mapper = DefaultTypeMapper(context: ctx)
        
        return SwiftMethodSignatureGen(context: ctx, typeMapper: mapper)
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
            self.typeMapper =
                DefaultTypeMapper(context:
                    TypeConstructionContext(typeSystem:
                        IntentionCollectionTypeSystem(intentions: intentions)
                    )
                )
        }
        
        func converts(toInitializer parameters: [ParameterSignature], file: String = #file, line: Int = #line) {
            guard let ctor = type.constructors.first else {
                testCase.recordFailure(withDescription: """
                    Failed to generate initializer: No initializers where found \
                    on target type.
                    Resulting type: \(dumpType())
                    """
                    , inFile: file, atLine: line, expected: false)
                return
            }
            guard ctor.parameters != parameters else {
                return
            }
            
            testCase.recordFailure(withDescription: """
                Expected to generate constructor with parameters \(parameters),
                but converted to \(ctor.parameters)
                """
                , inFile: file, atLine: line, expected: false)
        }
        
        func converts(toInitializer expected: String, file: String = #file, line: Int = #line) {
            guard let ctor = type.constructors.first else {
                testCase.recordFailure(withDescription: """
                    Failed to generate initializer: No initializers where found \
                    on target type.
                    Resulting type: \(dumpType())
                    """
                    , inFile: file, atLine: line, expected: false)
                return
            }
            
            let result = "init" + TypeFormatter.asString(parameters: ctor.parameters)
            
            guard result != expected else {
                return
            }
            
            testCase.recordFailure(withDescription: """
                Expected to generate constructor with parameters \(expected),
                but converted to \(result)
                """
                , inFile: file, atLine: line, expected: false)
        }
        
        func converts(to signature: FunctionSignature, file: String = #file, line: Int = #line) {
            guard type.methods.first?.signature != signature else {
                return
            }
            
            testCase.recordFailure(withDescription: """
                Expected signature \(TypeFormatter.asString(signature: signature, includeName: true)), \
                but converted to \(TypeFormatter.asString(signature: type.methods[0].signature, includeName: true))
                """
                , inFile: file, atLine: line, expected: false)
        }
        
        func converts(to signature: String, file: String = #file, line: Int = #line) {
            guard let method = type.methods.first else {
                testCase.recordFailure(withDescription: """
                    Failed to generate method: No methods where found on \
                    target type.
                    Resulting type: \(dumpType())
                    """
                    , inFile: file, atLine: line, expected: false)
                return
            }
            
            let converted = TypeFormatter.asString(signature: method.signature, includeName: true)
            guard converted != signature else {
                return
            }
            
            testCase.recordFailure(withDescription: """
                Expected signature \(signature), but converted to \(converted)
                """
                , inFile: file, atLine: line, expected: false)
        }
        
        func dumpType() -> String {
            return
                type.methods
                    .map { "Method: \(TypeFormatter.asString(signature: $0.signature, includeName: true))" }
                    .joined(separator: "\n")
        }
    }
}
