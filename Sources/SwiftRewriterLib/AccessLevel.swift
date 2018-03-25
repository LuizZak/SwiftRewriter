/// Access level visibility for a member or type
public enum AccessLevel: String {
    case `private`
    case `fileprivate`
    case `internal`
    case `public`
    
    /// Returns `true` if this access level value is of higher visibility than
    /// the one provided.
    public func isMoreVisible(than other: AccessLevel) -> Bool {
        switch (self, other) {
            
        case (.public, .public),
             (.internal, .internal),
             (.fileprivate, .fileprivate),
             (.private, .private):
            return false
            
        case (.private, _):
            return false
        case (.fileprivate, .private):
            return true
        case (.internal, .private), (.internal, .fileprivate):
            return true
        case (.public, .private), (.public, .fileprivate), (.public, .internal):
            return true
            
        default:
            return false
        }
    }
}
