import XCTest
import Antlr4
import GrammarModels
import ObjcParser
import ObjcParserAntlr

/// Used as a basis for test fixtures that test specific parser rules.
class BaseParserTestFixture {
    private var _retainedParser: ObjectiveCParserAntlr?

    let parserState = ObjcParserState()
    
    /// Requests that a specified source code string be parsed by a provided
    /// rule deriver.
    ///
    /// Throws an error if any parsing error was encountered.
    func parse<T: ParserRuleContext>(
        _ string: String,
        file: StaticString = #file,
        line: UInt = #line,
        ruleDeriver: (ObjectiveCParser) -> () throws -> T
    ) throws -> T {
        
        let parserLexer = try parserState.makeMainParser(input: string)
        _retainedParser = parserLexer

        let parser = parserLexer.parser
        let errorListener = ErrorListener()
        parser.removeErrorListeners()
        parser.addErrorListener(errorListener)
        
        return try withExtendedLifetime(parser) {
            let rule = try ruleDeriver(parser)()
            
            if errorListener.hasErrors {
                throw Error.parsingErrors(errorListener.errorDescription)
            }
            
            return rule
        }
    }

    enum Error: Swift.Error, CustomStringConvertible {
        /// General errors collected by an error listener during parsing.
        case parsingErrors(String)

        var description: String {
            switch self {
            case .parsingErrors(let value):
                return "Parsing error: \(value)"
            }
        }
    }
}

/// Stores a single parser rule that is applied to every input source when
/// `parse(_:file:line:)` is called.
class SingleRuleParserTestFixture<T: ParserRuleContext>: BaseParserTestFixture {
    let ruleDeriver: (ObjectiveCParser) -> () throws -> T
    
    /// Initializes a parser test fixture with a fixed rule deriver associated
    /// with it.
    init(ruleDeriver: @escaping (ObjectiveCParser) -> () throws -> T) {
        self.ruleDeriver = ruleDeriver
    }

    /// Requests that a specified source code string be parsed by the current
    /// rule deriver configured in this test fixture.
    ///
    /// Throws an error if any parsing error was encountered.
    func parse(
        _ string: String,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T {
        
        return try parse(string, ruleDeriver: ruleDeriver)
    }
}
