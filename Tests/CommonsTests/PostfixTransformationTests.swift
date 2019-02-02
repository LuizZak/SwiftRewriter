import XCTest
import Commons
import SwiftAST

class PostfixTransformationTests: XCTestCase {
    // MARK: - Method transformer
    func testFunctionIdentifierAliasesWithMethodTransformer() {
        let rewriter = MethodInvocationRewriterBuilder().build()
        let transformer =
            MethodInvocationTransformerMatcher(
                identifier: FunctionIdentifier(name: "oldMethod", parameterNames: [nil, "arg1"]),
                isStatic: false,
                transformer: rewriter
            )
        let sut = PostfixTransformation.method(transformer)
        
        XCTAssertEqual(sut.functionIdentifierAliases,
                       [FunctionIdentifier(name: "oldMethod", parameterNames: [nil, "arg1"])])
    }
    
    // MARK: Function invocation transformer
    func testFunctionIdentifierAliasesWithFunctionInvocationTransformerFromFunction() {
        let transformer =
            FunctionInvocationTransformer(
                fromObjcFunctionName: "oldFunction",
                destinationMember: .method("newMethod",
                                           firstArgumentBecomesInstance: false,
                                           [.asIs, .asIs])
            )
        let sut = PostfixTransformation.function(transformer)
        
        XCTAssertEqual(sut.functionIdentifierAliases,
                       [FunctionIdentifier(name: "oldFunction", parameterNames: [nil, nil])])
    }
    
    func testFunctionIdentifierAliasesWithFunctionInvocationTransformerFromPropertyGetter() {
        let transformer =
            FunctionInvocationTransformer(
                fromObjcFunctionName: "oldFunction",
                destinationMember: .propertyGetter("property")
            )
        let sut = PostfixTransformation.function(transformer)
        
        XCTAssertEqual(sut.functionIdentifierAliases,
                       [FunctionIdentifier(name: "oldFunction", parameterNames: [nil])])
    }
    
    func testFunctionIdentifierAliasesWithFunctionInvocationTransformerFromPropertySetter() {
        let transformer =
            FunctionInvocationTransformer(
                fromObjcFunctionName: "oldFunction",
                destinationMember: .propertySetter("property", argumentTransformer: .asIs)
            )
        let sut = PostfixTransformation.function(transformer)
        
        XCTAssertEqual(sut.functionIdentifierAliases,
                       [FunctionIdentifier(name: "oldFunction", parameterNames: [nil, nil])])
    }
    
    func testFunctionIdentifierAliasesWithPropertyFromMethods() {
        let getter = PostfixTransformation
            .propertyFromMethods(
                property: "prop",
                getterName: "getProp",
                setterName: nil,
                resultType: .int,
                isStatic: false
            )
        let getterAndSetter = PostfixTransformation
            .propertyFromMethods(
                property: "prop",
                getterName: "getProp",
                setterName: "setProp",
                resultType: .int,
                isStatic: false
            )
        
        XCTAssertEqual(getter.functionIdentifierAliases,
                       [FunctionIdentifier(name: "getProp", parameterNames: [])])
        XCTAssertEqual(getterAndSetter.functionIdentifierAliases,
                       [FunctionIdentifier(name: "getProp", parameterNames: []),
                        FunctionIdentifier(name: "setProp", parameterNames: [nil])])
    }
    
    func testFunctionIdentifierAliasesWithPropertyFromFreeFunctions() {
        let getter = PostfixTransformation
            .propertyFromFreeFunctions(property: "prop", getterName: "getProp", setterName: nil)
        let getterAndSetter = PostfixTransformation
            .propertyFromFreeFunctions(property: "prop", getterName: "getProp", setterName: "setProp")
        
        XCTAssertEqual(getter.functionIdentifierAliases,
                       [FunctionIdentifier(name: "getProp", parameterNames: [nil])])
        XCTAssertEqual(getterAndSetter.functionIdentifierAliases,
                       [FunctionIdentifier(name: "getProp", parameterNames: [nil]),
                        FunctionIdentifier(name: "setProp", parameterNames: [nil, nil])])
    }
}
