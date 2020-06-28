import XCTest
import GrammarModels
import ObjcParser
import ObjcParserAntlr
import Antlr4

class TypeParsingTests: XCTestCase {
    func testParseObjcTypeInFieldDeclarationContext() {
        prepareTester(ObjectiveCParser.fieldDeclaration, { $0.parseObjcType(in: $1) }) { tester in
            tester.assert("int a;", parsesAs: .struct("int"))
            tester.assert("int *a;", parsesAs: .pointer(.struct("int")))
        }
    }
    
    func testParseObjcTypeInFieldDeclarationContextMultiple() {
        let sut = makeSut()
        
        withParserRule("int a, *b", { try $0.fieldDeclaration() }) { rule in
            XCTAssertEqual(sut.parseObjcTypes(in: rule), [.struct("int"), .pointer(.struct("int"))])
        }
    }
    
    func testParseObjcTypeInSpecifierQualifierListContext() {
        prepareTester(ObjectiveCParser.specifierQualifierList, { $0.parseObjcType(in: $1) }) { tester in
            tester.assert("int", parsesAs: .struct("int"))
            tester.assert("int *", parsesAs: .pointer(.struct("int")))
            tester.assert("long long", parsesAs: .struct("long long"))
            tester.assert("__weak NSObject*", parsesAs: .specified(specifiers: ["__weak"], .pointer(.struct("NSObject"))))
            tester.assert("__weak _Nonnull NSObject*", parsesAs: .specified(specifiers: ["__weak", "_Nonnull"], .pointer(.struct("NSObject"))))
        }
    }
}

private extension TypeParsingTests {
    func prepareTester<T: ParserRuleContext>(_ ruleDeriver: (ObjectiveCParser) -> () throws -> T,
                                             _ parseMethod: (TypeParsing, T) -> ObjcType?,
                                             _ test: (Tester<T>) -> Void) {
        
        withoutActuallyEscaping(ruleDeriver) { ruleDeriver in
            withoutActuallyEscaping(parseMethod) { parseMethod in
                let tester = Tester<T>(ruleDeriver: ruleDeriver,
                                       parseMethod: parseMethod,
                                       typeParsing: self.makeSut())
                
                test(tester)
            }
        }
    }
    
    func withParserRule<T: ParserRuleContext>(_ string: String, _ closure: (ObjectiveCParser) throws -> T, _ test: (T) -> Void) {
        let parserState = ObjcParserState()
        let parser = try! parserState.makeMainParser(input: string).parser
        
        withExtendedLifetime(parser) {
            let rule = try! closure(parser)
            
            test(rule)
        }
    }
    
    func makeSut() -> TypeParsing {
        let state = ObjcParserState()
        return TypeParsing(state: state)
    }
    
    struct Tester<T: ParserRuleContext> {
        let parserState = ObjcParserState()
        let ruleDeriver: (ObjectiveCParser) -> () throws -> T
        let parseMethod: (TypeParsing, T) -> ObjcType?
        let typeParsing: TypeParsing
        
        init(ruleDeriver: @escaping (ObjectiveCParser) -> () throws -> T,
             parseMethod: @escaping (TypeParsing, T) -> ObjcType?,
             typeParsing: TypeParsing) {
            
            self.ruleDeriver = ruleDeriver
            self.parseMethod = parseMethod
            self.typeParsing = typeParsing
        }
        
        func assert(_ string: String, parsesAs expected: ObjcType, line: UInt = #line) {
            let parser = try! parserState.makeMainParser(input: string).parser
            
            withExtendedLifetime(parser) {
                let rule = try! ruleDeriver(parser)()
                let result = parseMethod(typeParsing, rule)
                
                var resultStr = ""
                var expectStr = ""
                dump(result, to: &resultStr)
                dump(expected, to: &expectStr)
                
                XCTAssertEqual(result, expected, "(\(resultStr)) is not equal to (\(expectStr))", line: line)
            }
        }
    }
}
