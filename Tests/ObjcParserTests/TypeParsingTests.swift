import XCTest
import GrammarModels
import ObjcParser
import ObjcParserAntlr
import Antlr4

class TypeParsingTests: XCTestCase {
    func testParseObjcType_fieldDeclarationContext() {
        prepareTester(ObjectiveCParser.fieldDeclaration, { $0.parseObjcType(in: $1) }) { tester in
            tester.assert("int a;", parsesAs: .struct("int"))
            tester.assert("int *a;", parsesAs: .pointer(.struct("int")))
            tester.assert("__weak NSObject *a;", parsesAs: .specified(specifiers: ["__weak"], .pointer(.struct("NSObject"))))
        }
    }
    
    func testParseObjcType_fieldDeclarationContext_multiple() {
        let sut = makeSut()
        
        withParserRule("int a, *b;", { try $0.fieldDeclaration() }) { rule in
            XCTAssertEqual(sut.parseObjcTypes(in: rule), [.struct("int"), .pointer(.struct("int"))])
        }
    }
    
    func testParseObjcType_fieldDeclarationContext_multiple_withArcBehavior() {
        let sut = makeSut()
        
        withParserRule("__weak NSObject *a;", { try $0.fieldDeclaration() }) { rule in
            XCTAssertEqual(sut.parseObjcTypes(in: rule), [.specified(specifiers: ["__weak"], .pointer(.struct("NSObject")))])
        }
    }
    
    /*
    func testParseObjcType_specifierQualifierListContext() {
        prepareTester(ObjectiveCParser.specifierQualifierList, { $0.parseObjcType(in: $1) }) { tester in
            tester.assert("int", parsesAs: .struct("int"))
            tester.assert("int *", parsesAs: .pointer(.struct("int")))
            tester.assert("long long", parsesAs: .struct("long long"))
            tester.assert("__weak NSObject*", parsesAs: .specified(specifiers: ["__weak"], .pointer(.struct("NSObject"))))
            tester.assert("__weak _Nonnull NSObject*", parsesAs: .specified(specifiers: ["__weak", "_Nonnull"], .pointer(.struct("NSObject"))))
        }
    }
    */
    
    func testParseObjcType_declarationSpecifiersContext() {
        prepareTester(ObjectiveCParser.declarationSpecifiers, { $0.parseObjcType(in: $1) }) { tester in
            tester.assert("__weak NSObject *a", parsesAs: .specified(specifiers: ["__weak"], .pointer(.struct("NSObject"))))
        }
    }
    
    func testParseObjcType_typeVariableDeclaratorContext_blockType() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(from: $1) }) { tester in
            tester.assert("NSObject (^)()", parsesAs: .blockType(name: nil, returnType: .struct("NSObject"), parameters: []))
        }
    }
    
    func testParseObjcType_declarationSpecifiers_declaratorContext_blockType() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(in: $1.declarationSpecifiers()!, declarator: $1.declarator()!) }) { tester in
            tester.assert("NSObject (^)()", parsesAs: .blockType(name: nil, returnType: .struct("NSObject"), parameters: []))
        }
    }
    
    func testParseObjcType_declarationSpecifiers_declaratorContext_fixedArray() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(in: $1.declarationSpecifiers()!, declarator: $1.declarator()!) }) { tester in
            tester.assert("NSObject (a)[2]", parsesAs: .fixedArray(.struct("NSObject"), length: 2))
        }
    }
    
    func testParseObjcType_typeVariableDeclaratorOrNameContext_blockType() {
        prepareTester(ObjectiveCParser.typeVariableDeclaratorOrName, { $0.parseObjcType(from: $1) }) { tester in
            tester.assert("NSObject (^)void", parsesAs: .blockType(name: nil, returnType: .struct("NSObject"), parameters: []))
        }
    }
    
    func testParseObjcType_declarationSpecifiers_declaratorContext_unsignedInteger() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(in: $1.declarationSpecifiers()!, declarator: $1.declarator()!) }) { tester in
            tester.assert("unsigned a", parsesAs: .struct("unsigned"))
        }
    }
    
    // TODO: Make this test pass
    func xtestParseObjcTypeInTypeVariableDeclaratorOrNameContext_fixedArray() {
        prepareTester(ObjectiveCParser.typeVariableDeclaratorOrName, { $0.parseObjcType(from: $1) }) { tester in
            tester.assert("NSObject (a)[2]", parsesAs: .fixedArray(.struct("NSObject"), length: 2))
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
    
    func withParserRule<T: ParserRuleContext>(_ string: String,
                                              _ closure: (ObjectiveCParser) throws -> T,
                                              _ test: (T) -> Void,
                                              line: UInt = #line) {
        
        let parserState = ObjcParserState()
        let parser = try! parserState.makeMainParser(input: string).parser
        let errorListener = ErrorListener()
        parser.removeErrorListeners()
        parser.addErrorListener(errorListener)
        
        withExtendedLifetime(parser) {
            let rule = try! closure(parser)
            
            if errorListener.hasErrors {
                XCTFail("Parser errors while parsing '\(string)': \(errorListener.errorDescription)", line: line)
            }
            
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
            let errorListener = ErrorListener()
            parser.removeErrorListeners()
            parser.addErrorListener(errorListener)
            
            withExtendedLifetime(parser) {
                let rule = try! ruleDeriver(parser)()
                
                if errorListener.hasErrors {
                    XCTFail("Parser errors while parsing '\(string)': \(errorListener.errorDescription)", line: line)
                }
                
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
