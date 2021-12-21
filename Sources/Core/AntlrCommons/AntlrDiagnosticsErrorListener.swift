import Antlr4
import Utils

public class AntlrDiagnosticsErrorListener: BaseErrorListener {
    public let source: Source
    public let diagnostics: Diagnostics
    public var debugDiagnostics: Bool = false
    
    public init(source: Source, diagnostics: Diagnostics) {
        self.source = source
        self.diagnostics = diagnostics
        super.init()
    }
    
    public override func syntaxError<T>(_ recognizer: Recognizer<T>,
                                        _ offendingSymbol: AnyObject?,
                                        _ line: Int,
                                        _ charPositionInLine: Int,
                                        _ msg: String,
                                        _ e: AnyObject?) where T : ATNSimulator {
        
        diagnostics.error(
            msg,
            origin: source.filePath,
            location: SourceLocation(line: line, column: charPositionInLine, utf8Offset: 0))
    }

    public override func reportAmbiguity(_ recognizer: Parser,
                                         _ dfa: DFA<ParserATNConfig>,
                                         _ startIndex: Int,
                                         _ stopIndex: Int,
                                         _ exact: Bool,
                                         _ ambiguousAlts: BitSet,
                                         _ configs: ATNConfigSet<ParserATNConfig>) {

        guard debugDiagnostics else { return }

        diagnostics.warning("""
            Ambiguity found: @ \(startIndex)-\(stopIndex) alts: \(ambiguousAlts)
            """,
            origin: source.filePath,
            location: .invalid
        )
    }

    public override func reportAttemptingFullContext(_ recognizer: Parser,
                                                     _ dfa: DFA<ParserATNConfig>,
                                                     _ startIndex: Int,
                                                     _ stopIndex: Int,
                                                     _ conflictingAlts: BitSet?,
                                                     _ configs: ATNConfigSet<ParserATNConfig>) {

        guard debugDiagnostics else { return }

        diagnostics.warning("""
            Attempting full context: @ \(startIndex)-\(stopIndex) alts: \(conflictingAlts?.description ?? "<nil>")
            """,
            origin: source.filePath,
            location: .invalid
        )
    }

    public override func reportContextSensitivity(_ recognizer: Parser,
                                                  _ dfa: DFA<ParserATNConfig>,
                                                  _ startIndex: Int,
                                                  _ stopIndex: Int,
                                                  _ prediction: Int,
                                                  _ configs: ATNConfigSet<ParserATNConfig>) {

        guard debugDiagnostics else { return }
        
        diagnostics.warning("""
            Context sensitivity found: @ \(startIndex)-\(stopIndex) prediction: \(prediction)
            """,
            origin: source.filePath,
            location: .invalid
        )
    }
}
