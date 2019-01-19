import XCTest
import IntentionPasses
import TestCommons
import SwiftAST
import Intentions
import SwiftRewriterLib

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
        testFlagsBody(as: .convenience, [
            .expression(
                Expression
                    .identifier("self")
                    .assignment(op: .assign,
                                rhs: Expression.identifier("self").dot("init").call([.constant(1)]))
            )
        ])
    }
    
    func testInitThatReturnsNil() {
        testFlagsBody(as: .failable, [
            .return(.constant(.nil))
        ])
    }
    
    func testInitThatHasBlockThatReturnsNil() {
        testFlagsBody(as: .none, [
            .expression(
                .block(body: [
                    .return(.constant(.nil))
                ])
            )
        ])
    }
    
    func testIgnoreWithinIfWithNilCheckSelf() {
        // Tests that the following case does not trigger the failable init detector:
        //
        // if(self == nil) {
        //     return nil;
        // }
        
        testFlagsBody(as: .none, [
            .if(Expression.identifier("self").binary(op: .equals, rhs: .constant(.nil)),
                body: [
                    .return(.constant(.nil))
                ], else: nil)
        ])
    }
    
    func testIgnoreWithinIfWithNilCheckSelfEqualsSuperInit() {
        // Tests that the following case does not trigger the failable init detector:
        //
        // if(!(self = [super init])) {
        //     return nil;
        // }
        
        testFlagsBody(as: .none, [
            .if(.unary(op: .negate,
                       Expression
                        .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: Expression.identifier("super").dot("init").call()
                        )
                ),
                body: [
                    .return(.constant(.nil))
                ], else: nil)
            ])
    }
    
    func testIgnoreWithinIfWithNilCheckSelfEqualsSelfInit() {
        // Tests that the following case does not trigger the failable init detector:
        //
        // if(!(self = [self init])) {
        //     return nil;
        // }
        
        testFlagsBody(as: .convenience, [
            .if(.unary(op: .negate,
                       Expression
                        .identifier("self")
                        .assignment(
                            op: .assign,
                            rhs: Expression.identifier("self").dot("init").call()
                        )
                ),
                body: [
                    .return(.constant(.nil))
                ], else: nil)
            ])
    }
}

private extension InitAnalysisIntentionPassTests {
    
    func testFlagsBody(as flags: InitFlags, _ body: CompoundStatement, line: Int = #line) {
        
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
            
            recordFailure(withDescription: """
                Expected to flag initializer as \(expFlagsString) but found \
                \(actFlagsString) instead.
                """, inFile: #file, atLine: line, expected: true)
        }
    }
    
    func flagsFromConstructor(_ ctor: InitGenerationIntention) -> InitFlags {
        var flags: InitFlags = []
        if ctor.isFailable {
            flags.insert(.failable)
        }
        if ctor.isConvenience {
            flags.insert(.convenience)
        }
        
        return flags
    }
    
    struct InitFlags: Hashable, OptionSet, CustomStringConvertible {
        let rawValue: Int
        
        var description: String {
            var descs: [String] = []
            
            if self.contains(.none) {
                descs.append("none")
            }
            if self.contains(.failable) {
                descs.append("failable")
            }
            if self.contains(.convenience) {
                descs.append("convenience")
            }
            
            return descs.joined(separator: ", ")
        }
        
        static let none = InitFlags(rawValue: 0)
        static let failable = InitFlags(rawValue: 1)
        static let convenience = InitFlags(rawValue: 2)
    }
}
