import MiniLexer
import GrammarModels

/// Container for diagnostic messages during parsing
public class Diagnostics {
    private(set) public var diagnostics: [DiagnosticMessage] = []
    
    public init() {
        
    }
    
    public var errors: [DiagnosticMessage] {
        return diagnostics.filter { if case .error = $0 { return true }; return false }
    }
    
    public var warnings: [DiagnosticMessage] {
        return diagnostics.filter { if case .warning = $0 { return true }; return false }
    }
    
    public var note: [DiagnosticMessage] {
        return diagnostics.filter { if case .note = $0 { return true }; return false }
    }
    
    public func error(_ message: String, location: SourceLocation) {
        let diag = DiagnosticMessage.error(message: message, location: location)
        
        diagnostics.append(diag)
    }
    
    public func warning(_ message: String, location: SourceLocation) {
        let diag = DiagnosticMessage.warning(message: message, location: location)
        
        diagnostics.append(diag)
    }
    
    public func note(_ message: String, location: SourceLocation) {
        let diag = DiagnosticMessage.note(message: message, location: location)
        
        diagnostics.append(diag)
    }
}

/// A single diagnostic message
public enum DiagnosticMessage: CustomStringConvertible {
    case note(message: String, location: SourceLocation)
    case warning(message: String, location: SourceLocation)
    case error(message: String, location: SourceLocation)
    
    public var description: String {
        switch self {
        case let .warning(message, loc):
            return "\(message) at \(loc)"
        case let .note(message, loc):
            return "\(message) at \(loc)"
        case let .error(message, loc):
            return "\(message) at \(loc)"
        }
    }
    
    public var location: SourceLocation {
        switch self {
        case .error(_, let loc):
            return loc
        case .warning(_, let loc):
            return loc
        case .note(_, let loc):
            return loc
        }
    }
}
