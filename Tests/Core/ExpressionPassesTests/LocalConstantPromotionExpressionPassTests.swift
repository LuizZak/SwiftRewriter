import Intentions
import KnownType
import SwiftAST
import SwiftRewriterLib
import TypeSystem
import XCTest

@testable import ExpressionPasses

class LocalConstantPromotionExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = LocalConstantPromotionExpressionPass.self
        intentionContext = .global(
            GlobalFunctionGenerationIntention(
                signature: FunctionSignature(name: "test")
            )
        )
    }

    func testDetectTrivialLetConstant() {
        let body: CompoundStatement = [
            Statement.variableDeclaration(
                identifier: "test",
                type: .int,
                initialization: .constant(0)
            )
        ]

        assertTransform(
            statement: body,
            into: CompoundStatement(statements: [
                Statement.variableDeclaration(
                    identifier: "test",
                    type: .int,
                    isConstant: true,
                    initialization: .constant(0)
                )
            ])
        )
    }

    func testNonConstantCase() {
        let body: CompoundStatement = [
            Statement.variableDeclaration(
                identifier: "test",
                type: .int,
                initialization: .constant(0)
            ),
            Statement.expression(
                Expression
                    .identifier("test")
                    .assignment(op: .assign, rhs: .constant(1))
            ),
        ]
        
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: body)

        assertNoTransform(
            statement: body
        )
    }

    // Weak variables cannot be 'let' constants; make sure we detect that and skip
    // promoting weak variables by mistake.
    func testDoNotPromoteWeakValues() {
        let body: CompoundStatement = [
            Statement.variableDeclaration(
                identifier: "test",
                type: .int,
                ownership: .weak,
                isConstant: false,
                initialization: .constant(0)
            )
        ]
        
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: body)

        assertNoTransform(
            statement: body
        )
    }

    func testDoNotPromoteWriteUsagesInVariableDeclaration() {
        let body: CompoundStatement = [
            // var test: Int
            Statement.variableDeclaration(
                identifier: "test",
                type: .int,
                isConstant: false,
                initialization: .constant(0)
            ),
            // var result = takesReference(&a)
            Statement.variableDeclaration(
                identifier: "result",
                type: .int,
                isConstant: false,
                initialization:
                    .identifier("takesReference")
                    .call([.identifier("test").unary(op: .bitwiseAnd)])
            )
        ]
        
        let resolver = ExpressionTypeResolver(typeSystem: TypeSystem.defaultTypeSystem)
        _ = resolver.resolveTypes(in: body)


        assertTransform(
            statement: body,
            into: CompoundStatement(statements: [
                // var test: Int
                Statement.variableDeclaration(
                    identifier: "test",
                    type: .int,
                    isConstant: false,
                    initialization: .constant(0)
                ),
                // let result = takesReference(&a)
                Statement.variableDeclaration(
                    identifier: "result",
                    type: .int,
                    isConstant: true,
                    initialization:
                        .identifier("takesReference")
                        .call([.identifier("test").unary(op: .bitwiseAnd)])
                )
            ])
        )
    }
}
