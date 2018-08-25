import XCTest
import ExpressionPasses
import SwiftAST
import SwiftRewriterLib

class CanonicalNameExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()
        
        sut = CanonicalNameExpressionPass(context: makeContext())
        
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
            expression: Expression.identifier("NonCanon").setDefinition(typeName: "NonCanon"),
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
                .setDefinition(localName: "local", type: .int),
            into: Expression
                .identifier("NonCanon")
        ); assertDidNotNotifyChange()
        
        assertTransform(
            expression: Expression
                .identifier("NonCanon")
                .setDefinition(globalName: "local", type: .int),
            into: Expression
                .identifier("NonCanon")
        ); assertDidNotNotifyChange()
        
        assertTransform(
            expression: Expression
                .identifier("NonCanon")
                .setDefinition(memberOf: KnownTypeBuilder(typeName: "A").build(),
                               member: KnownTypeBuilder(typeName: "A")
                                .property(named: "a", type: .int)
                                .build()
                                .knownProperties[0]),
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
