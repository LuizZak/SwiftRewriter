import GrammarModels

/// An intention that comes from the reading of a source code file, instead of
/// being synthesized
public class FromSourceIntention: Intention, NonNullScopedIntention {
    public var accessLevel: AccessLevel
    
    /// Gets the file intention this intention is associated with, if available.
    public var file: FileGenerationIntention? {
        var parent: Intention? = self
        
        while let p = parent {
            parent = p.parent
            
            if let file = parent as? FileGenerationIntention {
                return file
            }
        }
        
        return nil
    }
    
    // NOTE: This is a hack- shouldn't be recorded on the intention but passed to
    // it in a more abstract way.
    // For now we leave it as it is since it works!
    /// Whether this intention was collected between NS_ASSUME_NONNULL_BEGIN/END
    /// macros.
    public var inNonnullContext: Bool = false
    
    public init(accessLevel: AccessLevel, source: ASTNode?) {
        self.accessLevel = accessLevel
        
        super.init(source: source)
    }
    
    /// Returns `true` if this intention's symbol is visible for a given intention.
    ///
    /// - Parameter intention: A source-based intention to compare the visibility
    /// of
    /// - Returns: `true` if this intention's symbol is visible within the given
    /// intention, `false` otherwise.
    public func isVisible(for intention: FromSourceIntention) -> Bool {
        switch accessLevel {
        // Internal/public/open are visible everywhere
        case .internal, .public, .open:
            return true
            
        case .fileprivate:
            return file?.targetPath == intention.file?.targetPath
            
        // Type-level visibility
        case .private:
            switch (self, intention) {
                // Private file-level member is visible to all other declarations
            // on the same file
            case (is FileLevelIntention, _):
                return self.file?.targetPath == intention.file?.targetPath
                
            case let (rhs as MemberGenerationIntention, lhs as TypeGenerationIntention):
                // Not visible to other types
                if rhs.type?.typeName != lhs.typeName {
                    return false
                }
                
                // Member of type is only visible within the same file
                if lhs.file?.targetPath == rhs.type?.file?.targetPath {
                    return true
                }
                
                return false
                
            case let (lhs as MemberGenerationIntention, rhs as MemberGenerationIntention):
                // Not visible to other types
                if lhs.type?.typeName != rhs.type?.typeName {
                    return false
                }
                
                // Members of types declared within a file are visible to all
                // extensions of the type declared within that same file
                if (lhs.type is ClassExtensionGenerationIntention || lhs.type is ClassGenerationIntention) &&
                    (rhs.type is ClassExtensionGenerationIntention || rhs.type is ClassGenerationIntention) {
                    return lhs.file?.targetPath == rhs.file?.targetPath
                }
                
                return false
            default:
                return false
            }
        }
    }
}
