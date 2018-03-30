import GrammarModels
import SwiftAST

/// An intention to generate a backing field for a property
public class PropertySynthesizationIntention: FromSourceIntention {
    public var propertyName: String
    public var ivarName: String
    
    public var type: SynthesizeType
    
    /// If `true`, this synthesization intention originated from a `@synthesize`
    /// directive from source code.
    ///
    /// May be false when synthesization occurred implicitly after a reference to
    /// a backing field was detected within a type.
    public var isExplicit: Bool
    
    public init(propertyName: String, ivarName: String, isExplicit: Bool, type: SynthesizeType,
                source: ASTNode? = nil) {
        self.propertyName = propertyName
        self.ivarName = ivarName
        self.isExplicit = isExplicit
        self.type = type
        
        super.init(accessLevel: .internal, source: source)
    }
    
    public enum SynthesizeType {
        case synthesize
        case dynamic
    }
}
