/// Container for diagnostic messages during parsing
public class Diagnostics {
    @ConcurrentValue private var _diagnostics: [DiagnosticMessage] = []
    public var diagnostics: [DiagnosticMessage] {
        return _diagnostics
    }
    
    public var errors: [DiagnosticMessage] {
        diagnostics.filter { if case .error = $0 { return true }; return false }
    }
    
    public var warnings: [DiagnosticMessage] {
        diagnostics.filter { if case .warning = $0 { return true }; return false }
    }
    
    public var notes: [DiagnosticMessage] {
        diagnostics.filter { if case .note = $0 { return true }; return false }
    }
    
    public init() {
        
    }
    
    public func copy() -> Diagnostics {
        let new = Diagnostics()
        new._diagnostics = diagnostics
        return new
    }
    
    public func diagnosticsSummary(includeNotes: Bool = false) -> String {
        var diag = ""
        printDiagnostics(to: &diag, includeNotes: includeNotes)
        return diag
    }
    
    public func printDiagnostics<Target>(to output: inout Target,
                                         includeNotes: Bool = false) where Target: TextOutputStream {
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
    
    public func merge(with other: Diagnostics) {
        _diagnostics.append(contentsOf: other.diagnostics)
    }
    
    public func error(_ message: String, origin: String? = nil, location: SourceLocation) {
        let diag =
            DiagnosticMessage.error(
                ErrorDiagnostic(message: message, origin: origin, location: location))
        
        _diagnostics.append(diag)
    }
    
    public func warning(_ message: String, origin: String? = nil, location: SourceLocation) {
        let diag =
            DiagnosticMessage.warning(message: message, origin: origin, location: location)
        
        _diagnostics.append(diag)
    }
    
    public func note(_ message: String, origin: String? = nil, location: SourceLocation) {
        let diag =
            DiagnosticMessage.note(message: message, origin: origin, location: location)
        
        _diagnostics.append(diag)
    }
    
    public func errorDiagnostics() -> [ErrorDiagnostic] {
        diagnostics.compactMap {
            switch $0 {
            case .error(let error):
                return error
            default:
                return nil
            }
        }
    }
    
    public func removeAll() {
        _diagnostics.removeAll()
    }
}

/// A single diagnostic message
public enum DiagnosticMessage: CustomStringConvertible {
    case note(message: String, origin: String?, location: SourceLocation)
    case warning(message: String, origin: String?, location: SourceLocation)
    case error(ErrorDiagnostic)
    
    public var description: String {
        switch self {
        case let .warning(message, origin, location),
             let .note(message, origin, location):
            
            if let origin = origin {
                return "\(message) at \(origin) line \(location.line) column \(location.column)"
            }
            
            return "\(message) line \(location.line) column \(location.column)"
            
        case let .error(error):
            return error.description
        }
    }
    
    public var location: SourceLocation {
        switch self {
        case .warning(_, _, let loc):
            return loc
        case .note(_, _, let loc):
            return loc
        case .error(let error):
            return error.location
        }
    }
}

public struct ErrorDiagnostic: CustomStringConvertible, Error {
    var message: String
    var origin: String?
    var location: SourceLocation
    
    public var description: String {
        if let origin = origin {
            return "\(message) at \(origin) line \(location.line) column \(location.column)"
        }
        
        return "\(message) line \(location.line) column \(location.column)"
    }
}
