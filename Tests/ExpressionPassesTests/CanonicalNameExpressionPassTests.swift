import XCTest
import ExpressionPasses
import SwiftAST
import KnownType
import SwiftRewriterLib

class CanonicalNameExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sutType = CanonicalNameExpressionPass.self
        
        let typeProvider = CollectionKnownTypeProvider()
        typeProvider.addCanonicalMapping(nonCanonical: "NonCanon",
                                         canonical: "Canon")
        
        typeSystem.addKnownTypeProvider(typeProvider)
    }
    
    func testTransformCanonicalTypeName() {
        assertTransform(
            expression: .identifier("NonCanon"),
            into: .identifier("Canon")
        ); assertNotifiedChange()
        
        assertTransform(
            expression: Expression.identifier("NonCanon").settingDefinition(.forType(named: "NonCanon")),
            into: .identifier("Canon")
        ); assertNotifiedChange()
    }
    
    func testTransformCanonicalTypeNameWithMetatypeResolvedType() {
        assertTransform(
            expression: Expression.identifier("NonCanon").typed(.metatype(for: "NonCanon")),
            into: .identifier("Canon")
        ); assertNotifiedChange()
    }
    
    func testDontTransformUnknownTypeName() {
        assertTransform(
            expression: .identifier("Unexisting"),
            into: .identifier("Unexisting")
        ); assertDidNotNotifyChange()
    }
    
    func testDontTransformIdentifiersWhichFeaturesNonTypeDefinitions() {
        assertTransform(
            expression: Expression
                .identifier("NonCanon")
                .settingDefinition(CodeDefinition.forSetterValue(named: "setter", type: .int)),
            into: Expression
                .identifier("NonCanon")
        ); assertDidNotNotifyChange()
        
        assertTransform(
            expression: Expression
                .identifier("NonCanon")
                .settingDefinition(.forGlobalVariable(name: "global", isConstant: false, type: .int)),
            into: Expression
                .identifier("NonCanon")
        ); assertDidNotNotifyChange()
        
        assertTransform(
            expression: Expression
                .identifier("NonCanon")
                .settingDefinition(
                    .forKnownMember(
                        KnownTypeBuilder(typeName: "A")
                            .property(named: "a", type: .int)
                            .build()
                            .knownProperties[0]
                    )
                ),
            into: Expression
                .identifier("NonCanon")
        ); assertDidNotNotifyChange()
    }
    
    func testDontTransformIdentifiersWhichFeaturesNonMetatypeResolvedType() {
        assertTransform(
            expression: Expression
                .identifier("NonCanon")
                .typed(.int),
            into: Expression
                .identifier("NonCanon")
        ); assertDidNotNotifyChange()
        
        assertTransform(
            expression: Expression
                .identifier("NonCanon")
                .typed(.string),
            into: Expression
                .identifier("NonCanon")
        ); assertDidNotNotifyChange()
        
        assertTransform(
            expression: Expression
                .identifier("NonCanon")
                .typed(.optional(.metatype(for: "NonCanon"))),
            into: Expression
                .identifier("NonCanon")
        ); assertDidNotNotifyChange()
    }
}
