import Intentions
import SwiftAST
import SwiftRewriterLib
import TestCommons
import XCTest

@testable import IntentionPasses

class InitAnalysisIntentionPassTests: XCTestCase {
    var sut: InitAnalysisIntentionPass!

    override func setUp() {
        super.setUp()

        sut = InitAnalysisIntentionPass()
    }

    func testEmptyInit() {
        testFlagsBody(as: .none, CompoundStatement(statements: []))
    }

    func testFlagsInitAsConvenienceInit() {
        testFlagsBody(
            as: .convenience,
            [
                .expression(
                    Expression
                        .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: Expression.identifier("self").dot("init").call([.constant(1)])
                        )
                )
            ]
        )
    }

    func testInitThatReturnsNil() {
        testFlagsBody(
            as: .fallible,
            [
                .return(.constant(.nil))
            ]
        )
    }

    func testInitThatHasBlockThatReturnsNil() {
        testFlagsBody(
            as: .none,
            [
                .expression(
                    .block(body: [
                        .return(.constant(.nil))
                    ])
                )
            ]
        )
    }

    func testIgnoreWithinIfWithNilCheckSelf() {
        // Tests that the following case does not trigger the fallible init detector:
        //
        // if(self == nil) {
        //     return nil;
        // }

        testFlagsBody(
            as: .none,
            [
                .if(
                    Expression.identifier("self").binary(op: .equals, rhs: .constant(.nil)),
                    body: [
                        .return(.constant(.nil))
                    ]
                )
            ]
        )
    }

    func testIgnoreWithinIfWithNilCheckSelfEqualsSuperInit() {
        // Tests that the following case does not trigger the fallible init detector:
        //
        // if(!(self = [super init])) {
        //     return nil;
        // }

        testFlagsBody(
            as: .none,
            [
                .if(
                    .unary(
                        op: .negate,
                        Expression
                            .identifier("self")
                            .assignment(
                                op: .assign,
                                rhs: Expression.identifier("super").dot("init").call()
                            )
                    ),
                    body: [
                        .return(.constant(.nil))
                    ]
                )
            ]
        )
    }

    func testIgnoreWithinIfWithNilCheckSelfEqualsSelfInit() {
        // Tests that the following case does not trigger the fallible init detector:
        //
        // if(!(self = [self init])) {
        //     return nil;
        // }

        testFlagsBody(
            as: .convenience,
            [
                .if(
                    .unary(
                        op: .negate,
                        Expression
                            .identifier("self")
                            .assignment(
                                op: .assign,
                                rhs: Expression.identifier("self").dot("init").call()
                            )
                    ),
                    body: [
                        .return(.constant(.nil))
                    ]
                )
            ]
        )
    }
}

extension InitAnalysisIntentionPassTests {

    fileprivate func testFlagsBody(
        as flags: InitFlags,
        _ body: CompoundStatement,
        line: UInt = #line
    ) {

        let intentions =
            IntentionCollectionBuilder()
            .createFileWithClass(named: "A") { type in
                type.createConstructor { ctor in
                    ctor.setBody(body)
                }
            }.build()
        let ctor = intentions.classIntentions()[0].constructors[0]

        sut.apply(on: intentions, context: makeContext(intentions: intentions))

        let actFlags = flagsFromConstructor(ctor)

        if actFlags != flags {
            let actFlagsString = actFlags.description
            let expFlagsString = flags.description

            XCTFail(
                """
                Expected to flag initializer as \(expFlagsString) but found \
                \(actFlagsString) instead.
                """,
                file: #filePath,
                line: line
            )
        }
    }

    fileprivate func flagsFromConstructor(_ ctor: InitGenerationIntention) -> InitFlags {
        var flags: InitFlags = []
        if ctor.isFallible {
            flags.insert(.fallible)
        }
        if ctor.isConvenience {
            flags.insert(.convenience)
        }

        return flags
    }

    fileprivate struct InitFlags: Hashable, OptionSet, CustomStringConvertible {
        let rawValue: Int

        var description: String {
            var descs: [String] = []

            if self.contains(.none) {
                descs.append("none")
            }
            if self.contains(.fallible) {
                descs.append("fallible")
            }
            if self.contains(.convenience) {
                descs.append("convenience")
            }

            return descs.joined(separator: ", ")
        }

        static let none = InitFlags([])
        static let fallible = InitFlags(rawValue: 1)
        static let convenience = InitFlags(rawValue: 2)
    }
}
