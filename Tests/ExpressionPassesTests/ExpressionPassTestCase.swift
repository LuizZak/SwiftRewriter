import XCTest
import Antlr4
import ObjcParser
import ObjcParserAntlr
import SwiftRewriterLib
import SwiftAST

class ExpressionPassTestCase: XCTestCase {
    static var _state: ObjcParserState = ObjcParserState()
    
    var notified: Bool = false
    var sut: ASTRewriterPass!
    var typeSystem: DefaultTypeSystem!
    
    override func setUp() {
        super.setUp()
        
        typeSystem = DefaultTypeSystem()
        notified = false
    }
    
    func assertNotifiedChange(file: String = #file, line: Int = #line) {
        if !notified {
            recordFailure(withDescription:
                """
                Expected syntax rewriter \(type(of: sut!)) to notify change via \
                \(\ASTRewriterPassContext.notifyChangedTree), but it did not.
                """,
                inFile: file, atLine: line, expected: true)
        }
    }
    
    func assertDidNotNotifyChange(file: String = #file, line: Int = #line) {
        if notified {
            recordFailure(withDescription:
                """
                Expected syntax rewriter \(type(of: sut!)) to not notify any changes \
                via \(\ASTRewriterPassContext.notifyChangedTree), but it did.
                """,
                inFile: file, atLine: line, expected: true)
        }
    }
    
    @discardableResult
    func assertTransformParsed(expression original: String, into expected: String,
                               file: String = #file, line: Int = #line) -> Expression {
        notified = false
        let exp = parse(original, file: file, line: line)
        
        let result = sut.apply(on: exp, context: makeContext())
        
        if expected != result.description {
            recordFailure(withDescription:
                "Failed to convert: Expected to convert expression\n\n\(expected)\n\nbut received\n\n\(result.description)",
                inFile: file, atLine: line, expected: true)
        }
        
        return result
    }
    
    @discardableResult
    func assertTransformParsed(expression original: String, into expected: Expression,
                               file: String = #file, line: Int = #line) -> Expression {
        let exp = parse(original, file: file, line: line)
        return assertTransform(expression: exp, into: expected, file: file, line: line)
    }
    
    @discardableResult
    func assertTransformParsed(statement original: String, into expected: Statement,
                               file: String = #file, line: Int = #line) -> Statement {
        let stmt = parseStmt(original, file: file, line: line)
        return assertTransform(statement: stmt, into: expected, file: file, line: line)
    }
    
    @discardableResult
    func assertTransform(expression: Expression, into expected: Expression,
                         file: String = #file, line: Int = #line) -> Expression {
        notified = false
        let result = sut.apply(on: expression, context: makeContext())
        
        if expected != result {
            var expString = ""
            var resString = ""
            
            dump(expected, to: &expString)
            dump(result, to: &resString)
            
            recordFailure(withDescription: "Failed to convert: Expected to convert expression into\n\(expString)\nbut received\n\(resString)",
                          inFile: file, atLine: line, expected: true)
        }
        
        return result
    }
    
    @discardableResult
    func assertTransform(statement: Statement, into expected: Statement,
                         file: String = #file, line: Int = #line) -> Statement {
        notified = false
        let result = sut.apply(on: statement, context: makeContext())
        
        if expected != result {
            var expString = ""
            var resString = ""
            
            dump(expected, to: &expString)
            dump(result, to: &resString)
            
            recordFailure(withDescription: "Failed to convert: Expected to convert statement into\n\(expString)\nbut received\n\(resString)",
                          inFile: file, atLine: line, expected: true)
        }
        
        return result
    }
    
    func parse(_ exp: String, file: String = #file, line: Int = #line) -> Expression {
        let (stream, parser) = objcParser(for: exp)
        defer {
            _=stream // Keep alive!
        }
        let diag = DiagnosticsErrorListener(source: StringCodeSource(source: exp),
                                            diagnostics: Diagnostics())
        parser.addErrorListener(diag)
        
        let expression = try! parser.expression()
        
        if !diag.diagnostics.diagnostics.isEmpty {
            let summary = diag.diagnostics.diagnosticsSummary()
            recordFailure(withDescription:
                "Unexpected diagnostics while parsing expression:\n\(summary)",
                inFile: file, atLine: line, expected: true)
        }
        
        let typeMapper = DefaultTypeMapper(typeSystem: DefaultTypeSystem())
        
        let reader = SwiftExprASTReader(typeMapper: typeMapper,
                                        typeParser: TypeParsing(state: ExpressionPassTestCase._state))
        return expression.accept(reader)!
    }
    
    func parseStmt(_ stmtString: String, file: String = #file, line: Int = #line) -> Statement {
        let (stream, parser) = objcParser(for: stmtString)
        defer {
            _=stream // Keep alive!
        }
        let diag = DiagnosticsErrorListener(source: StringCodeSource(source: stmtString),
                                            diagnostics: Diagnostics())
        parser.addErrorListener(diag)
        
        let stmt = try! parser.statement()
        
        if !diag.diagnostics.diagnostics.isEmpty {
            let summary = diag.diagnostics.diagnosticsSummary()
            recordFailure(withDescription:
                "Unexpected diagnostics while parsing statement:\n\(summary)",
                inFile: file, atLine: line, expected: true)
        }
        
        let typeMapper = DefaultTypeMapper(typeSystem: DefaultTypeSystem())
        let typeParser = TypeParsing(state: ExpressionPassTestCase._state)
        
        let expReader = SwiftExprASTReader(typeMapper: typeMapper, typeParser: typeParser)
        let reader = SwiftStatementASTReader(expressionReader: expReader)
        
        return stmt.accept(reader)!
    }
    
    func objcParser(for objc: String) -> (CommonTokenStream, ObjectiveCParser) {
        let parser = try! ExpressionPassTestCase._state.makeMainParser(input: objc)
        return (parser.tokens, parser.parser)
    }
    
    func makeContext() -> ASTRewriterPassContext {
        let block: () -> Void = { [weak self] in
            self?.notified = true
        }
        
        return ASTRewriterPassContext(typeSystem: typeSystem,
                                             notifyChangedTree: block)
    }
}
