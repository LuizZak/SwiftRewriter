import XCTest
import GrammarModels
@testable import ObjcParser

class ObjcLexer_TokenizerTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testTokenizeIdentifiers() {
        expect("AnIdentifier", toTokenizeAs: .identifier("AnIdentifier"))
        expect("_AnIdentifier_", toTokenizeAs: .identifier("_AnIdentifier_"))
    }
    
    func testTokenizeId() {
        expect("id", toTokenizeAs: .id)
    }
    
    func testTokenizeTypeQualifier() {
        expect("extern", toTokenizeAs: .typeQualifier("extern"))
        expect("static", toTokenizeAs: .typeQualifier("static"))
        expect("const", toTokenizeAs: .typeQualifier("const"))
        expect("volatile", toTokenizeAs: .typeQualifier("volatile"))
        expect("signed", toTokenizeAs: .typeQualifier("signed"))
        expect("unsigned", toTokenizeAs: .typeQualifier("unsigned"))
        expect("_Nonnull", toTokenizeAs: .typeQualifier("_Nonnull"))
        expect("_Nullable", toTokenizeAs: .typeQualifier("_Nullable"))
        expect("__weak", toTokenizeAs: .typeQualifier("__weak"))
        expect("__strong", toTokenizeAs: .typeQualifier("__strong"))
        expect("__kindof", toTokenizeAs: .typeQualifier("__kindof"))
        expect("__block", toTokenizeAs: .typeQualifier("__block"))
        expect("__unused", toTokenizeAs: .typeQualifier("__unused"))
    }
    
    func testTokenizeAlphanumericKeywords() {
        expect("if", toTokenizeAs: .keyword(.if))
        expect("else", toTokenizeAs: .keyword(.else))
        expect("while", toTokenizeAs: .keyword(.while))
        expect("switch", toTokenizeAs: .keyword(.switch))
        expect("continue", toTokenizeAs: .keyword(.continue))
        expect("break", toTokenizeAs: .keyword(.break))
        expect("return", toTokenizeAs: .keyword(.return))
        expect("typedef", toTokenizeAs: .keyword(.typedef))
        expect("struct", toTokenizeAs: .keyword(.struct))
    }
    
    func testTokenizeAtKeywords() {
        expect("@interface", toTokenizeAs: .keyword(.atInterface))
        expect("@implementation", toTokenizeAs: .keyword(.atImplementation))
        expect("@protocol", toTokenizeAs: .keyword(.atProtocol))
        expect("@end", toTokenizeAs: .keyword(.atEnd))
        expect("@public", toTokenizeAs: .keyword(.atPublic))
        expect("@protected", toTokenizeAs: .keyword(.atProtected))
        expect("@private", toTokenizeAs: .keyword(.atPrivate))
        expect("@package", toTokenizeAs: .keyword(.atPackage))
        expect("@optional", toTokenizeAs: .keyword(.atOptional))
        expect("@required", toTokenizeAs: .keyword(.atRequired))
        expect("@class", toTokenizeAs: .keyword(.atClass))
    }
    
    func testTokenizeSpecialChars() {
        expect("@", toTokenizeAs: .at)
        expect(":", toTokenizeAs: .colon)
        expect(";", toTokenizeAs: .semicolon)
        expect(",", toTokenizeAs: .comma)
        expect("(", toTokenizeAs: .openParens)
        expect(")", toTokenizeAs: .closeParens)
        expect("[", toTokenizeAs: .openSquareBracket)
        expect("]", toTokenizeAs: .closeSquareBracket)
        expect("{", toTokenizeAs: .openBrace)
        expect("}", toTokenizeAs: .closeBrace)
        expect(".", toTokenizeAs: .period)
        expect("...", toTokenizeAs: .ellipsis)
    }
    
    func testTokenizeOperators() {
        expect("+", toTokenizeAs: .operator(.add))
        expect("-", toTokenizeAs: .operator(.subtract))
        expect("*", toTokenizeAs: .operator(.multiply))
        expect("/", toTokenizeAs: .operator(.divide))
        
        expect("+=", toTokenizeAs: .operator(.addAssign))
        expect("-=", toTokenizeAs: .operator(.subtractAssign))
        expect("*=", toTokenizeAs: .operator(.multiplyAssign))
        expect("/=", toTokenizeAs: .operator(.divideAssign))
        
        expect("!", toTokenizeAs: .operator(.negate))
        expect("&&", toTokenizeAs: .operator(.and))
        expect("||", toTokenizeAs: .operator(.or))
        
        expect("&", toTokenizeAs: .operator(.bitwiseAnd))
        expect("|", toTokenizeAs: .operator(.bitwiseOr))
        expect("^", toTokenizeAs: .operator(.bitwiseXor))
        expect("~", toTokenizeAs: .operator(.bitwiseNot))
        expect("<<", toTokenizeAs: .operator(.bitwiseShiftLeft))
        expect(">>", toTokenizeAs: .operator(.bitwiseShiftRight))
        
        expect("&=", toTokenizeAs: .operator(.bitwiseAndAssign))
        expect("|=", toTokenizeAs: .operator(.bitwiseOrAssign))
        expect("^=", toTokenizeAs: .operator(.bitwiseXorAssign))
        expect("~=", toTokenizeAs: .operator(.bitwiseNotAssign))
        expect("<<=", toTokenizeAs: .operator(.bitwiseShiftLeftAssign))
        expect(">>=", toTokenizeAs: .operator(.bitwiseShiftRightAssign))
        
        expect("<", toTokenizeAs: .operator(.lessThan))
        expect("<=", toTokenizeAs: .operator(.lessThanOrEqual))
        expect(">", toTokenizeAs: .operator(.greaterThan))
        expect(">=", toTokenizeAs: .operator(.greaterThanOrEqual))
        
        expect("=", toTokenizeAs: .operator(.assign))
        expect("==", toTokenizeAs: .operator(.equals))
        expect("!=", toTokenizeAs: .operator(.unequals))
    }
    
    func testTokenizeSequence() {
        expect(sequence: "const __weak identifier",
               toTokenizeAs: [.typeQualifier("const"), .typeQualifier("__weak"), .identifier("identifier")])
    }
}

extension ObjcLexer_TokenizerTests {
    
    private func expect(sequence string: String, toTokenizeAs expectedTypes: [TokenType],
                        file: String = #file, line: Int = #line) {
        
        let lexer = makeLexer(string)
        
        for pair in zip(lexer.allTokens(), expectedTypes) {
            
            let actual = pair.0
            let expected = pair.1
            
            if actual.tokenType != expected {
                recordFailure(
                    withDescription:
                    """
                    Expected token type: \(expected) received token: \
                    \(actual) at loc. \(actual.range as Any)
                    """,
                    inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    private func expect(_ string: String, toTokenizeAs expectedType: TokenType,
                        _ expectedString: String? = nil,
                        file: String = #file, line: Int = #line) {
        
        let expString = expectedString ?? string
        
        let token =
            ObjcLexer.Token(value: expString, tokenType: expectedType,
                            range: fullRange(expString))
        
        tokenizeTest(string, token, file: file, line: line)
    }
    
    private func tokenizeTest(_ string: String, _ expected: ObjcLexer.Token,
                              file: String = #file, line: Int = #line) {
        
        let lexer = makeLexer(string)
        
        if lexer.token() != expected {
            recordFailure(withDescription: "Expected token: \(expected) received token: \(lexer.token())",
                          inFile: file, atLine: line, expected: true)
        }
    }
    
    private func makeLexer(_ string: String) -> ObjcLexer {
        let lexer = ObjcLexer(source: StringCodeSource(source: string))
        return lexer
    }
    
    private func fullRange(_ str: String) -> Range<String.Index> {
        return str.startIndex..<str.endIndex
    }
}
