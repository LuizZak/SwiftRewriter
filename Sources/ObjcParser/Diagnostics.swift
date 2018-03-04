import MiniLexer
import GrammarModels

/// Container for diagnostic messages during parsing
public class Diagnostics {
    private(set) public var diagnostics: [DiagnosticMessage] = []
    
    public var errors: [DiagnosticMessage] {
        return diagnostics.filter { if case .error = $0 { return true }; return false }
    }
    
    public var warnings: [DiagnosticMessage] {
        return diagnostics.filter { if case .warning = $0 { return true }; return false }
    }
    
    public var notes: [DiagnosticMessage] {
        return diagnostics.filter { if case .note = $0 { return true }; return false }
    }
    
    public init() {
        
    }
    
    public func diagnosticsSummary(includeNotes: Bool = false) -> String {
        var diag = ""
        printDiagnostics(to: &diag, includeNotes: includeNotes)
        return diag
    }
    
    public func printDiagnostics<Target>(to output: inout Target, includeNotes: Bool = false) where Target: TextOutputStream {
        for error in errors {
            print("Error: " + error.description, to: &output)
        }
        
        for warning in warnings {
            print("Warning: " + warning.description, to: &output)
        }
        
        if includeNotes {
            for note in notes {
                print("Note: " + note.description, to: &output)
            }
        }
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
