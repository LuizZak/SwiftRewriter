import GrammarModelBase
import SwiftAST
import KnownType

/// An intention that comes from the reading of a source code file, instead of
/// being synthesized
public class FromSourceIntention: Intention, NonNullScopedIntention {
    public var accessLevel: AccessLevel
    
    /// A list of comments that precedes this intention in source code
    public var precedingComments: [String] = []
    
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
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.accessLevel = try container.decode(AccessLevel.self, forKey: .accessLevel)
        self.inNonnullContext = try container.decode(Bool.self, forKey: .inNonnullContext)
        self.precedingComments = try container.decode([String].self, forKey: .precedingComments)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(accessLevel, forKey: .accessLevel)
        try container.encode(inNonnullContext, forKey: .inNonnullContext)
        try container.encode(precedingComments, forKey: .precedingComments)
        
        try super.encode(to: container.superEncoder())
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
            // Private file-level member is visible to all other declarations on
            // the same file
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
    
    /// Returns `true` if this intention's symbol is visible for a given file intention.
    ///
    /// - Parameter file: A file intention to compare the visibility to
    /// - Returns: `true` if this intention's symbol is visible within the given
    /// file intention, `false` otherwise.
    public func isVisible(in file: FileGenerationIntention) -> Bool {
        switch accessLevel {
        // Internal/public/open are visible everywhere
        case .internal, .public, .open:
            return true
            
        case .fileprivate:
            return self.file?.targetPath == file.targetPath
            
        // Type-level visibility
        case .private:
            switch self {
            // Private file-level member is visible to all other declarations on
            // the same file
            case is FileLevelIntention:
                return self.file?.targetPath == file.targetPath
                
            default:
                return false
            }
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case accessLevel
        case inNonnullContext
        case precedingComments
    }
}

extension FromSourceIntention: KnownDeclaration {
    public var knownFile: KnownFile? {
        return file
    }
}
