import XCTest
import GrammarModels
import Antlr4
import ObjcParser
import ObjcParserAntlr

class VarDeclarationTypeExtractorTests: XCTestCase {
    
    var tokens: CommonTokenStream!
    
    func testReadVarDeclaration() {
        assertTypeVisit(objc: "NSString* abc;",
                        { try $0.varDeclaration() },
                        expected: "NSString*")
        
        assertTypeVisit(objc: "static const NSString*_Nonnull abc;",
                        { try $0.varDeclaration() },
                        expected: "static const NSString*_Nonnull")
    }
    
    func testReadTypeVariableDeclaratorOrName() {
        assertTypeVisit(objc: "void",
                        { try $0.typeVariableDeclaratorOrName() },
                        expected: "void")
        
        assertTypeVisit(objc: "const int",
                        { try $0.typeVariableDeclaratorOrName() },
                        expected: "const int")
        
        assertTypeVisit(objc: "nullable NSString *a;",
                        { try $0.typeVariableDeclaratorOrName() },
                        expected: "nullable NSString*")
    }
    
    func assertTypeVisit(objc: String, _ parseBlock: (ObjectiveCParser) throws -> ParserRuleContext,
                         expected: String, file: String = #file, line: Int = #line) {
        let sut = VarDeclarationTypeExtractor()
        
        do {
            let (toks, parser) = objcParser(for: objc)
            
            tokens = toks
            
            let parserRuleContext = try parseBlock(parser)
            
            let output = parserRuleContext.accept(sut)
            
            if output != expected {
                recordFailure(withDescription: """
                    Failed: Expected to translate Objective-C
                    \(objc)
                    
                    as
                    
                    \(expected)
                    
                    but translated as
                    
                    \(output as Any)
                    """, inFile: file, atLine: line, expected: true)
            }
        } catch {
            recordFailure(withDescription: "Unexpected error(s) parsing objective-c: \(error)",
                          inFile: file, atLine: line, expected: false)
        }
    }
    
    func objcParser(for objc: String) -> (CommonTokenStream, ObjectiveCParser) {
        let input = ANTLRInputStream(objc)
        let lxr = ObjectiveCLexer(input)
        let tokens = CommonTokenStream(lxr)
        
        let parser = try! ObjectiveCParser(tokens)
        
        return (tokens, parser)
    }
}
