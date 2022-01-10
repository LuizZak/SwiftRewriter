import XCTest
import SwiftAST
import Intentions
import SwiftSyntaxSupport
import TypeSystem
import TestCommons

@testable import Analysis

class DefinitionTypePropagatorTests: XCTestCase {
    func testPropagate_functionBodyIntention() {
        let sut = makeSut()
        let functionBody = FunctionBodyIntention(body: [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant(0)),
        ], source: nil)
        let intention = GlobalFunctionGenerationIntention(signature: .init(name: "f"))
        intention.functionBody = functionBody

        sut.propagate(in: .global(intention))
        
        assertEqual(functionBody.body, [
            .variableDeclaration(identifier: "a", type: .double, initialization: .constant(0)),
        ])
    }

    func testPropagate_functionBodyIntention_performTypeCoercionOfAssignments() {
        let sut = makeSut(numericType: .int)
        let functionBody = FunctionBodyIntention(body: [
            .variableDeclaration(identifier: "a", type: .any, initialization: nil),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0))),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0.0))),
        ], source: nil)
        let intention = GlobalFunctionGenerationIntention(signature: .init(name: "f"))
        intention.functionBody = functionBody

        sut.propagate(in: .global(intention))
        
        assertEqual(functionBody.body, [
            .variableDeclaration(identifier: "a", type: .double, initialization: nil),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0))),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0.0))),
        ])
    }
    
    func testPropagate_expression() {
        let sut = makeSut()
        let exp: Expression = .block(body: [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant(0)),
        ])

        let result = sut.propagate(exp)

        XCTAssertEqual(
            result,
            .block(body: [
                .variableDeclaration(identifier: "a", type: .double, initialization: .constant(0)),
            ])
        )
    }

    func testPropagate_simpleAssignment() {
        let sut = makeSut()
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant(0)),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .double, initialization: .constant(0)),
        ])
    }

    func testPropagate_sameAssignment() {
        let sut = makeSut()
        let body: CompoundStatement = [
            .variableDeclarations([
                .init(identifier: "a", type: .any, initialization: .constant(0)),
                .init(identifier: "b", type: .any, initialization: .identifier("a").binary(op: .subtract, rhs: .constant(0))),
            ]),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclarations([
                .init(identifier: "a", type: .double, initialization: .constant(0)),
                .init(identifier: "b", type: .double, initialization: .identifier("a").binary(op: .subtract, rhs: .constant(0))),
            ]),
        ])
    }

    func testPropagate_simpleAssignment_ignoreNonBaseTypes() {
        let sut = makeSut()
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .int, initialization: .constant(0)),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .int, initialization: .constant(0)),
        ])
    }

    func testPropagate_sequentialAssignments_numeric() {
        let sut = makeSut()
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant(0)),
            .variableDeclaration(identifier: "b", type: .any, initialization: .identifier("a")),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .double, initialization: .constant(0)),
            .variableDeclaration(identifier: "b", type: .double, initialization: .identifier("a")),
        ])
    }

    func testPropagate_sequentialAssignments_numeric_nilBaseNumericType_resolvesAsIs() {
        let sut = makeSut(numericType: nil)
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .uint, initialization: .constant(0)),
            .variableDeclaration(identifier: "b", type: .any, initialization: .identifier("a")),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .uint, initialization: .constant(0)),
            .variableDeclaration(identifier: "b", type: .uint, initialization: .identifier("a")),
        ])
    }

    func testPropagate_sequentialAssignments_string() {
        let sut = makeSut()
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant("literal")),
            .variableDeclaration(identifier: "b", type: .any, initialization: .identifier("a")),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .string, initialization: .constant("literal")),
            .variableDeclaration(identifier: "b", type: .string, initialization: .identifier("a")),
        ])
    }

    func testPropagate_sequentialAssignmentsWithDelayedFirstAssignment() {
        let sut = makeSut()
        let body: CompoundStatement = [
            .variableDeclarations([
                .init(identifier: "a", type: .any, initialization: nil),
                .init(identifier: "b", type: .any, initialization: .constant(0)),
            ]),
            .expression(.identifier("a").assignment(op: .assign, rhs: .identifier("b")))
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclarations([
                .init(identifier: "a", type: .double, initialization: nil),
                .init(identifier: "b", type: .double, initialization: .constant(0)),
            ]),
            .expression(.identifier("a").assignment(op: .assign, rhs: .identifier("b")))
        ])
    }

    func testPropagate_weakReferenceType() {
        let intentionCollection = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createConstructor()
            }.build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        let sut = makeSut(typeSystem: typeSystem)
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .identifier("A").call()),
            .variableDeclaration(identifier: "b", type: .any, ownership: .weak, initialization: .identifier("A").call()),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: "A", initialization: .identifier("A").call()),
            .variableDeclaration(identifier: "b", type: .typeName("A").asOptional, ownership: .weak, initialization: .identifier("A").call()),
        ])
    }

    func testPropagate_avoidPropagatingErrorTypes() {
        let intentionCollection = IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createGlobalVariable(withName: "foo", type: .errorType)
            }.build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        let sut = makeSut(typeSystem: typeSystem)
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .identifier("foo")),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .any, initialization: .identifier("foo")),
        ])
    }

    func testPropagate_nestedFunction() {
        /*
        func foo() -> Double {
            return 0
        }

        let bar: Any = foo()
        */
        let sut = makeSut()
        let body: CompoundStatement = [
            .localFunction(identifier: "foo", parameters: [], returnType: .double, body: [
                .return(.constant(0))
            ]),
            .variableDeclaration(identifier: "bar", type: .any, initialization: .identifier("foo").call()),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .localFunction(identifier: "foo", parameters: [], returnType: .double, body: [
                .return(.constant(0))
            ]),
            .variableDeclaration(identifier: "bar", type: .double, initialization: .identifier("foo").call()),
        ])
    }

    func testPropagate_nestedFunction_returnsBaseType_avoidInfiniteLoop() {
        /*
        func foo() -> Any {
            return 0
        }

        let bar: Any = foo()
        */
        let sut = makeSut()
        let body: CompoundStatement = [
            .localFunction(identifier: "foo", parameters: [], returnType: .any, body: [
                .return(.constant(0))
            ]),
            .variableDeclaration(identifier: "bar", type: .any, initialization: .identifier("foo").call()),
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .localFunction(identifier: "foo", parameters: [], returnType: .any, body: [
                .return(.constant(0))
            ]),
            .variableDeclaration(identifier: "bar", type: .any, initialization: .identifier("foo").call()),
        ])
    }

    func testPropagate_delayedAssignment() {
        let sut = makeSut()
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: nil),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0)))
        ]

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .double, initialization: nil),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0)))
        ])
    }

    // MARK: - Test internals

    private func makeSut(typeSystem: TypeSystem = TypeSystem(), numericType: SwiftType? = .double, stringType: SwiftType? = .string) -> DefinitionTypePropagator {
        return DefinitionTypePropagator(
            options: .init(
                baseType: .any,
                baseNumericType: numericType,
                baseStringType: stringType
            ),
            typeSystem: typeSystem,
            typeResolver: ExpressionTypeResolver(typeSystem: typeSystem)
        )
    }

    private func assertEqual<T: Statement>(
        _ statement: T,
        _ expected: T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard statement != expected else {
            return
        }

        let producer = SwiftSyntaxProducer()

        var expString = producer.generateStatement(expected).description + "\n"
        var resString = producer.generateStatement(statement).description + "\n"

        if expString == resString {
            dump(statement, to: &resString)
            dump(expected, to: &expString)
        }

        XCTFail(
            """
            Failed: Statements do not match, expected:

            \(expString)

            but received:

            \(resString)

            """,
            file: file,
            line: line
        )
    }
}
