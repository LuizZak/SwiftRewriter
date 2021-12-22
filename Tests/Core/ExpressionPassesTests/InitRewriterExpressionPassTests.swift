import Intentions
import KnownType
import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest

@testable import ExpressionPasses

class InitRewriterExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = InitRewriterExpressionPass.self
    }

    func testEmptyIfInInit() {
        // Tests an empty common init pattern rewrite
        //
        //   self = [super init];
        //   if(self) {
        //
        //   }
        //   return self;
        //
        // is rewritten as:
        //
        //   super.init()
        //

        intentionContext = .initializer(InitGenerationIntention(parameters: []))

        assertTransform(
            statement: .compound([
                .expression(
                    .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("super").dot("init").call()
                        )
                ),

                .if(.identifier("self"), body: []),

                .return(.identifier("self")),
            ]),
            into: .compound([
                .expression(.identifier("super").dot("init").call())
            ])
        )
        assertNotifiedChange()
    }

    func testEmptyIfInInitWithDelegatedSelfInit() {
        // Tests an empty init pattern rewrite with a delegated initializer call
        //
        //   self = [self init];
        //   if(self) {
        //
        //   }
        //   return self;
        //
        // is rewritten as:
        //
        //   self.init()
        //

        intentionContext = .initializer(InitGenerationIntention(parameters: []))

        assertTransform(
            statement: .compound([
                .expression(
                    .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("self").dot("init").call()
                        )
                ),

                .if(.identifier("self"), body: []),

                .return(.identifier("self")),
            ]),
            into: .compound([
                .expression(.identifier("self").dot("init").call())
            ])
        )
        assertNotifiedChange()
    }

    func testNonEmptyIfInInit() {
        // Tests an empty common init pattern rewrite with initializer code
        //
        //   self = [super init];
        //   if(self) {
        //       self.property = property;
        //   }
        //   return self;
        //
        // is rewritten as:
        //
        //   self.property = property
        //   super.init()
        //

        intentionContext = .initializer(InitGenerationIntention(parameters: []))

        assertTransform(
            statement: .compound([
                .expression(
                    .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("super").dot("init").call()
                        )
                ),

                .if(
                    .identifier("self"),
                    body: [
                        .expression(
                            .identifier("self").dot("init")
                                .assignment(op: .assign, rhs: .identifier("property"))
                        )
                    ]
                ),

                .return(.identifier("self")),
            ]),
            into: .compound([
                .expression(
                    .identifier("self").dot("init")
                        .assignment(op: .assign, rhs: .identifier("property"))
                ),
                .expression(.identifier("super").dot("init").call()),
            ])
        )
        assertNotifiedChange()
    }

    func testEarlyExitIfSuperInit() {
        // Tests an empty early-exit init pattern rewrite
        //
        //   if(!(self = [super init])) {
        //       return nil;
        //   }
        //   return self;
        //
        // is rewritten as:
        //
        //   super.init()
        //

        intentionContext = .initializer(InitGenerationIntention(parameters: []))

        assertTransform(
            statement:
                .compound([
                    .if(
                        Expression
                            .unary(
                                op: .negate,
                                .parens(
                                    .identifier("self")
                                        .assignment(
                                            op: .assign,
                                            rhs: .identifier("super").dot("init").call()
                                        )
                                )
                            ),
                        body: [
                            .return(.constant(.nil))
                        ]
                    ),
                    .return(.identifier("self")),
                ]),
            into: .compound([
                .expression(.identifier("super").dot("init").call())
            ])
        )
        assertNotifiedChange()
    }

    func testEarlyExitIfSuperInitNonEmpty() {
        // Tests an empty early-exit init pattern rewrite with initializer code
        //
        //   if(!(self = [super init])) {
        //       return nil;
        //   }
        //   self.property = property;
        //   return self;
        //
        // is rewritten as:
        //
        //   self.property = property;
        //   super.init()
        //

        intentionContext = .initializer(InitGenerationIntention(parameters: []))

        assertTransform(
            statement:
                .compound([
                    .if(
                        Expression
                            .unary(
                                op: .negate,
                                .parens(
                                    .identifier("self")
                                        .assignment(
                                            op: .assign,
                                            rhs: .identifier("super").dot("init").call()
                                        )
                                )
                            ),
                        body: [
                            .return(.constant(.nil))
                        ]
                    ),

                    .expression(
                        .identifier("self").dot("init")
                            .assignment(op: .assign, rhs: .identifier("property"))
                    ),

                    .return(.identifier("self")),
                ]),
            into: .compound([
                .expression(
                    .identifier("self").dot("init")
                        .assignment(op: .assign, rhs: .identifier("property"))
                ),
                .expression(.identifier("super").dot("init").call()),
            ])
        )
        assertNotifiedChange()
    }

    func testAddOptionalToOptionalSuperInit() {
        // Test that when we find a call to a base constructor that is failable,
        // we properly convert that call to a failable initializer invocation
        // (i.e. `super.init?()`)

        let typeA =
            KnownTypeBuilder(typeName: "A")
            .constructor(
                withParameters: [
                    ParameterSignature(label: nil, name: "value", type: .int)
                ],
                isFailable: true
            )
            .build()
        let typeB =
            KnownTypeBuilder(typeName: "B", supertype: typeA)
            .build()
        typeSystem.addType(typeA)
        typeSystem.addType(typeB)
        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "B") { type in
                type.inherit(from: "A")
                    .createConstructor()
            }.build()
        intentionContext = .initializer(intentions.classIntentions()[0].constructors[0])

        assertTransform(
            statement:
                .compound([
                    .expression(
                        .identifier("self")
                            .assignment(
                                op: .assign,
                                rhs: .identifier("super").dot("init").call([.constant(0)])
                            )
                    )
                ]),
            into: .compound([
                .expression(
                    .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: .identifier("super").dot("init").optional().call([.constant(0)])
                        )
                )
            ])
        )
        assertNotifiedChange()
    }
}
