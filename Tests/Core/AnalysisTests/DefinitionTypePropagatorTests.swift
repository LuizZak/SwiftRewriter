import XCTest
import SwiftAST
import Intentions
import SwiftSyntaxSupport
import TypeSystem
import TestCommons

@testable import Analysis

class DefinitionTypePropagatorTests: XCTestCase {
    func testComputeParameterTypes() {
        let function = GlobalFunctionGenerationIntention(
            signature: .init(
                name: "f",
                parameters: [
                    .init(name: "a", type: .any),
                    .init(name: "b", type: .any),
                    .init(name: "c", type: .any),
                ]
            )
        )
        function.functionBody = FunctionBodyIntention(body: [
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0))),
            .expression(.identifier("b").assignment(op: .assign, rhs: .constant(true))),
            .expression(.identifier("c").assignment(op: .assign, rhs: .identifier("unknown"))),
        ])
        let carrier = FunctionBodyCarryingIntention.global(function)
        let sut = makeSut(intention: carrier)

        let result = sut.computeParameterTypes(in: function)

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], .double)
        XCTAssertEqual(result[1], .bool)
        XCTAssertNil(result[2])
    }

    func testComputeParameterTypes_dontSuggestTypesForAlreadyTypedParameters() {
        let function = GlobalFunctionGenerationIntention(
            signature: .init(
                name: "f",
                parameters: [
                    .init(name: "a", type: .any),
                    .init(name: "b", type: .double),
                    .init(name: "c", type: .bool),
                ]
            )
        )
        function.functionBody = FunctionBodyIntention(body: [
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0))),
            .expression(.identifier("b").assignment(op: .assign, rhs: .constant(true))),
            .expression(.identifier("b").assignment(op: .assign, rhs: .identifier("unknown"))),
        ])
        let carrier = FunctionBodyCarryingIntention.global(function)
        let sut = makeSut(intention: carrier)

        let result = sut.computeParameterTypes(in: function)

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], .double)
        XCTAssertNil(result[1])
        XCTAssertNil(result[2])
    }

    func testPropagate_functionBodyIntention() {
        let functionBody = FunctionBodyIntention(body: [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant(0)),
        ], source: nil)
        let intention = GlobalFunctionGenerationIntention(signature: .init(name: "f"))
        intention.functionBody = functionBody
        let carrier = FunctionBodyCarryingIntention.global(intention)
        let sut = makeSut(intention: carrier)

        sut.propagate(in: carrier)
        
        assertEqual(functionBody.body, [
            .variableDeclaration(identifier: "a", type: .double, initialization: .constant(0)),
        ])
    }

    func testPropagate_functionBodyIntention_performTypeCoercionOfAssignments() {
        let functionBody = FunctionBodyIntention(body: [
            .variableDeclaration(identifier: "a", type: .any, initialization: nil),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0))),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0.0))),
        ], source: nil)
        let intention = GlobalFunctionGenerationIntention(signature: .init(name: "f"))
        intention.functionBody = functionBody
        let carrier = FunctionBodyCarryingIntention.global(intention)
        let sut = makeSut(intention: carrier, numericType: .int)

        sut.propagate(in: carrier)
        
        assertEqual(functionBody.body, [
            .variableDeclaration(identifier: "a", type: .double, initialization: nil),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0))),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0.0))),
        ])
    }
    
    func testPropagate_functionBody_avoidPropagatingErrorTypes() {
        let intentionCollection = IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createGlobalVariable(withName: "foo", type: .errorType)
            }.build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        let body: FunctionBodyIntention = FunctionBodyIntention(body: [
            .variableDeclaration(identifier: "a", type: .any, initialization: .identifier("foo")),
        ])
        let function = GlobalFunctionGenerationIntention(signature: .init(name: "foo"))
        function.functionBody = body
        let sut = makeSut(intention: .global(function), typeSystem: typeSystem)

        sut.propagate(body)

        assertEqual(body.body, [
            .variableDeclaration(identifier: "a", type: .any, initialization: .identifier("foo")),
        ] as CompoundStatement)
    }

    func testPropagate_expression() {
        let exp: Expression = .block(body: [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant(0)),
        ])
        let body: CompoundStatement = [
            .expression(exp)
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(exp)

        XCTAssertEqual(
            result,
            .block(body: [
                .variableDeclaration(identifier: "a", type: .double, initialization: .constant(0)),
            ])
        )
    }

    func testPropagate_simpleAssignment() {
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant(0)),
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .double, initialization: .constant(0)),
        ] as CompoundStatement)
    }

    func testPropagate_sameAssignment() {
        let body: CompoundStatement = [
            .variableDeclarations([
                .init(identifier: "a", type: .any, initialization: .constant(0)),
                .init(identifier: "b", type: .any, initialization: .identifier("a").binary(op: .subtract, rhs: .constant(0))),
            ]),
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclarations([
                .init(identifier: "a", type: .double, initialization: .constant(0)),
                .init(identifier: "b", type: .double, initialization: .identifier("a").binary(op: .subtract, rhs: .constant(0))),
            ]),
        ] as CompoundStatement)
    }

    func testPropagate_simpleAssignment_ignoreNonBaseTypes() {
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .int, initialization: .constant(0)),
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .int, initialization: .constant(0)),
        ] as CompoundStatement)
    }

    func testPropagate_sequentialAssignments_numeric() {
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant(0)),
            .variableDeclaration(identifier: "b", type: .any, initialization: .identifier("a")),
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .double, initialization: .constant(0)),
            .variableDeclaration(identifier: "b", type: .double, initialization: .identifier("a")),
        ] as CompoundStatement)
    }

    func testPropagate_sequentialAssignments_numeric_nilBaseNumericType_resolvesAsIs() {
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .uint, initialization: .constant(0)),
            .variableDeclaration(identifier: "b", type: .any, initialization: .identifier("a")),
        ]
        let sut = makeSut(body: body, numericType: nil)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .uint, initialization: .constant(0)),
            .variableDeclaration(identifier: "b", type: .uint, initialization: .identifier("a")),
        ] as CompoundStatement)
    }

    func testPropagate_sequentialAssignments_string() {
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .constant("literal")),
            .variableDeclaration(identifier: "b", type: .any, initialization: .identifier("a")),
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .string, initialization: .constant("literal")),
            .variableDeclaration(identifier: "b", type: .string, initialization: .identifier("a")),
        ] as CompoundStatement)
    }

    func testPropagate_sequentialAssignmentsWithDelayedFirstAssignment() {
        let body: CompoundStatement = [
            .variableDeclarations([
                .init(identifier: "a", type: .any, initialization: nil),
                .init(identifier: "b", type: .any, initialization: .constant(0)),
            ]),
            .expression(.identifier("a").assignment(op: .assign, rhs: .identifier("b")))
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclarations([
                .init(identifier: "a", type: .double, initialization: nil),
                .init(identifier: "b", type: .double, initialization: .constant(0)),
            ]),
            .expression(.identifier("a").assignment(op: .assign, rhs: .identifier("b")))
        ] as CompoundStatement)
    }

    func testPropagate_weakReferenceType() {
        let intentionCollection = IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createConstructor()
            }.build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .identifier("A").call()),
            .variableDeclaration(identifier: "b", type: .any, ownership: .weak, initialization: .identifier("A").call()),
        ]
        let sut = makeSut(body: body, typeSystem: typeSystem)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: "A", initialization: .identifier("A").call()),
            .variableDeclaration(identifier: "b", type: .typeName("A").asOptional, ownership: .weak, initialization: .identifier("A").call()),
        ] as CompoundStatement)
    }

    func testPropagate_avoidPropagatingErrorTypes() {
        let intentionCollection = IntentionCollectionBuilder()
            .createFile(named: "A") { file in
                file.createGlobalVariable(withName: "foo", type: .errorType)
            }.build()
        let typeSystem = IntentionCollectionTypeSystem(intentions: intentionCollection)
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: .identifier("foo")),
        ]
        let sut = makeSut(body: body, typeSystem: typeSystem)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .any, initialization: .identifier("foo")),
        ] as CompoundStatement)
    }

    func testPropagate_nestedFunction() {
        /*
        func foo() -> Double {
            return 0
        }

        let bar: Any = foo()
        */
        let body: CompoundStatement = [
            .localFunction(identifier: "foo", parameters: [], returnType: .double, body: [
                .return(.constant(0))
            ]),
            .variableDeclaration(identifier: "bar", type: .any, initialization: .identifier("foo").call()),
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .localFunction(identifier: "foo", parameters: [], returnType: .double, body: [
                .return(.constant(0))
            ]),
            .variableDeclaration(identifier: "bar", type: .double, initialization: .identifier("foo").call()),
        ] as CompoundStatement)
    }

    func testPropagate_nestedFunction_returnsBaseType_avoidInfiniteLoop() {
        /*
        func foo() -> Any {
            return 0
        }

        let bar: Any = foo()
        */
        let body: CompoundStatement = [
            .localFunction(identifier: "foo", parameters: [], returnType: .any, body: [
                .return(.constant(0))
            ]),
            .variableDeclaration(identifier: "bar", type: .any, initialization: .identifier("foo").call()),
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .localFunction(identifier: "foo", parameters: [], returnType: .any, body: [
                .return(.constant(0))
            ]),
            .variableDeclaration(identifier: "bar", type: .any, initialization: .identifier("foo").call()),
        ] as CompoundStatement)
    }

    func testPropagate_delayedAssignment() {
        let body: CompoundStatement = [
            .variableDeclaration(identifier: "a", type: .any, initialization: nil),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0)))
        ]
        let sut = makeSut(body: body)

        let result = sut.propagate(body)

        assertEqual(result, [
            .variableDeclaration(identifier: "a", type: .double, initialization: nil),
            .expression(.identifier("a").assignment(op: .assign, rhs: .constant(0)))
        ] as CompoundStatement)
    }

    // MARK: - Test internals

    private func makeSut(
        body: CompoundStatement,
        typeSystem: IntentionCollectionTypeSystem = IntentionCollectionTypeSystem(intentions: .init()),
        globals: DefinitionsSource = ArrayDefinitionsSource(),
        numericType: SwiftType? = .double,
        stringType: SwiftType? = .string
    ) -> DefinitionTypePropagator {

        let intention = GlobalFunctionGenerationIntention(
            signature: .init(name: "foo")
        )
        intention.functionBody = .init(body: body)

        return makeSut(
            intention: .global(intention),
            typeSystem: typeSystem,
            globals: globals,
            numericType: numericType,
            stringType: stringType
        )
    }

    private func makeSut(
        intention: FunctionBodyCarryingIntention,
        typeSystem: IntentionCollectionTypeSystem = IntentionCollectionTypeSystem(intentions: .init()),
        globals: DefinitionsSource = ArrayDefinitionsSource(),
        numericType: SwiftType? = .double,
        stringType: SwiftType? = .string
    ) -> DefinitionTypePropagator {
        
        let localTypeResolver = DefaultLocalTypeResolverInvoker(
            intention: intention,
            globals: globals,
            typeSystem: typeSystem
        )

        return makeSut(
            intention: intention,
            typeSystem: typeSystem,
            numericType: numericType,
            stringType: stringType,
            localTypeResolver: localTypeResolver
        )
    }

    private func makeSut(
        intention: FunctionBodyCarryingIntention,
        typeSystem: TypeSystem = TypeSystem(),
        numericType: SwiftType? = .double,
        stringType: SwiftType? = .string,
        localTypeResolver: DefaultLocalTypeResolverInvoker
    ) -> DefinitionTypePropagator {

        return .init(
            options: .init(
                baseType: .any,
                baseNumericType: numericType,
                baseStringType: stringType
            ),
            typeSystem: typeSystem,
            typeResolver: localTypeResolver
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
