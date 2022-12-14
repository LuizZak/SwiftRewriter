import Antlr4

class ErrorListener: BaseErrorListener {
    var errors: [String] = []
    
    var errorDescription: String {
        return errors.joined(separator: "\n")
    }
    
    var hasErrors: Bool {
        return !errors.isEmpty
    }
    
    override func syntaxError<T>(
        _ recognizer: Recognizer<T>,
        _ offendingSymbol: AnyObject?,
        _ line: Int,
        _ charPositionInLine: Int,
        _ msg: String,
        _ e: AnyObject?
    ) where T : ATNSimulator {
        
        errors.append(msg)
    }
}
