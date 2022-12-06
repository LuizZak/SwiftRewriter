import XCTest
import GrammarModels
import ObjcParser
import ObjcParserAntlr
import Antlr4

class TypeParsingTests: XCTestCase {
    func testParseObjcType_fieldDeclarationContext() {
        prepareTester(ObjectiveCParser.fieldDeclaration, { $0.parseObjcType(in: $1) }) { tester in
            tester.assert("int a;", parsesAs: .typeName("signed int"))
            tester.assert("int *a;", parsesAs: .pointer(.typeName("signed int")))
            tester.assert("__weak NSObject *a;", parsesAs: .pointer(.typeName("NSObject")).specifiedAsWeak)
        }
    }
    
    func testParseObjcType_fieldDeclarationContext_multiple() {
        let sut = makeSut(source: "int a, *b;")
        
        withParserRule("int a, *b;", { try $0.fieldDeclaration() }) { rule in
            XCTAssertEqual(
                sut.parseObjcTypes(in: rule), [
                    .typeName("signed int"),
                    .pointer(.typeName("signed int"))
                ]
            )
        }
    }
    
    func testParseObjcType_fieldDeclarationContext_multiple_withArcBehavior() {
        let sut = makeSut(source: "int a, *b;")
        
        withParserRule("__weak NSObject *a;", { try $0.fieldDeclaration() }) { rule in
            XCTAssertEqual(
                sut.parseObjcTypes(in: rule), [
                    .pointer(.typeName("NSObject")).specifiedAsWeak
                ]
            )
        }
    }
    
    func testParseObjcType_typeVariableDeclaratorContext_blockType() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(from: $1) }) { tester in
            tester.assert(
                "NSInteger (^)()",
                parsesAs: .blockType(
                    name: nil,
                    returnType: .typeName("NSInteger")
                )
            )
        }
    }
    
    func testParseObjcType_declarationSpecifiers_declaratorContext_blockType() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(in: $1.declarationSpecifiers()!, declarator: $1.declarator()!) }) { tester in
            tester.assert(
                "NSInteger (^)()",
                parsesAs: .blockType(
                    name: nil,
                    returnType: .typeName("NSInteger")
                )
            )
        }
    }
    
    func testParseObjcType_declarationSpecifiers_declaratorContext_blockType_nullabilitySpecifier() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(in: $1.declarationSpecifiers()!, declarator: $1.declarator()!) }) { tester in
            tester.assert(
                "NSInteger (^_Nonnull)()",
                parsesAs: .blockType(
                    name: nil,
                    returnType: .typeName("NSInteger"),
                    nullabilitySpecifier: .nonnull
                )
            )
        }
    }
    
    func testParseObjcType_declarationSpecifiers_declaratorContext_fixedArray() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(in: $1.declarationSpecifiers()!, declarator: $1.declarator()!) }) { tester in
            tester.assert(
                "NSInteger (a)[2]",
                parsesAs: .fixedArray(.typeName("NSInteger"), length: 2)
            )
        }
    }
    
    func testParseObjcType_parameterDeclaration_blockType() {
        prepareTester(ObjectiveCParser.parameterDeclaration, { $0.parseObjcType(from: $1) }) { tester in
            tester.assert(
                "NSInteger (^)()",
                parsesAs: .blockType(
                    name: nil,
                    returnType: .typeName("NSInteger")
                )
            )
        }
    }
    
    func testParseObjcType_parameterDeclaration_fixedArray() {
        prepareTester(ObjectiveCParser.parameterDeclaration, { $0.parseObjcType(from: $1) }) { tester in
            tester.assert(
                "NSInteger (a)[2]",
                parsesAs: .fixedArray(.typeName("NSInteger"), length: 2)
            )
        }
    }
    
    func testParseObjcType_declarationSpecifiers_declaratorContext_weakSpecifier() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(in: $1.declarationSpecifiers()!, declarator: $1.declarator()!) }) { tester in
            tester.assert(
                "__weak NSObject *a",
                parsesAs: .pointer(.typeName("NSObject")).specifiedAsWeak
            )
        }
    }
    
    func testParseObjcType_declarationSpecifiers_declaratorContext_unsignedInteger() {
        prepareTester(ObjectiveCParser.typeVariableDeclarator, { $0.parseObjcType(in: $1.declarationSpecifiers()!, declarator: $1.declarator()!) }) { tester in
            tester.assert(
                "unsigned a",
                parsesAs: .typeName("unsigned int")
            )
        }
    }
    
    func testParseObjcType_blockExpression() {
        prepareTester(ObjectiveCParser.blockExpression, { $0.parseObjcType(from: $1) }) { tester in
            // No return nor parameters
            tester.assert(
                "^{ }",
                parsesAs: .blockType(
                    name: nil,
                    returnType: .void
                )
            )
            // Return, no parameters
            tester.assert(
                "^NSInteger{ }",
                parsesAs: .blockType(
                    name: nil,
                    returnType: "NSInteger"
                )
            )
            // No return, parameters
            tester.assert(
                "^(int a, float b){ }",
                parsesAs: .blockType(
                    name: nil,
                    returnType: .void,
                    parameters: ["signed int", "float"]
                )
            )
            // Return, parameters
            tester.assert(
                "^NSInteger(int a, float b){ }",
                parsesAs: .blockType(
                    name: nil,
                    returnType: "NSInteger",
                    parameters: ["signed int", "float"]
                )
            )
        }
    }
}

private extension TypeParsingTests {
    func prepareTester<T: ParserRuleContext>(
        _ ruleDeriver: (ObjectiveCParser) -> () throws -> T,
        _ parseMethod: (TypeParsing, T) -> ObjcType?,
        _ test: (Tester<T>) -> Void
    ) {
        
        withoutActuallyEscaping(ruleDeriver) { ruleDeriver in
            withoutActuallyEscaping(parseMethod) { parseMethod in
                let tester = Tester<T>(
                    ruleDeriver: ruleDeriver,
                    parseMethod: parseMethod
                )
                
                test(tester)
            }
        }
    }
    
    func withParserRule<T: ParserRuleContext>(
        _ string: String,
        _ closure: (ObjectiveCParser) throws -> T,
        _ test: (T) -> Void,
        line: UInt = #line
    ) {
        
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
    
    func makeSut(source: String) -> TypeParsing {
        let state = ObjcParserState()

        return TypeParsing(
            state: state,
            source: StringCodeSource(source: source),
            nonnullContextQuerier: NonnullContextQuerier(nonnullMacroRegionsTokenRange: [])
        )
    }
    
    struct Tester<T: ParserRuleContext> {
        let parserState = ObjcParserState()
        let ruleDeriver: (ObjectiveCParser) -> () throws -> T
        let parseMethod: (TypeParsing, T) -> ObjcType?
        
        init(
            ruleDeriver: @escaping (ObjectiveCParser) -> () throws -> T,
            parseMethod: @escaping (TypeParsing, T) -> ObjcType?
        ) {
            
            self.ruleDeriver = ruleDeriver
            self.parseMethod = parseMethod
        }
        
        func assert(_ string: String, parsesAs expected: ObjcType, line: UInt = #line) {
            let parser = try! parserState.makeMainParser(input: string).parser
            let errorListener = ErrorListener()
            parser.removeErrorListeners()
            parser.addErrorListener(errorListener)

            let state = ObjcParserState()
            let sut = TypeParsing(
                state: state,
                source: StringCodeSource(source: string),
                nonnullContextQuerier: NonnullContextQuerier(nonnullMacroRegionsTokenRange: [])
            )
            
            withExtendedLifetime(parser) {
                let rule = try! ruleDeriver(parser)()
                
                if errorListener.hasErrors {
                    XCTFail("Parser errors while parsing '\(string)': \(errorListener.errorDescription)", line: line)
                }
                
                let result = parseMethod(sut, rule)
                
                var resultStr = ""
                var expectStr = ""
                dump(result, to: &resultStr)
                dump(expected, to: &expectStr)
                
                XCTAssertEqual(result, expected, "(\(resultStr)) is not equal to (\(expectStr))", line: line)
            }
        }
    }
}
