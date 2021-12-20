import ObjcGrammarModels
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
    
    public init(propertyName: String,
                ivarName: String,
                isExplicit: Bool,
                type: SynthesizeType,
                source: ObjcASTNode? = nil) {
        
        self.propertyName = propertyName
        self.ivarName = ivarName
        self.isExplicit = isExplicit
        self.type = type
        
        super.init(accessLevel: .internal, source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        propertyName = try container.decode(String.self, forKey: .propertyName)
        ivarName = try container.decode(String.self, forKey: .ivarName)
        type = try container.decode(SynthesizeType.self, forKey: .type)
        isExplicit = try container.decode(Bool.self, forKey: .isExplicit)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(propertyName, forKey: .propertyName)
        try container.encode(ivarName, forKey: .ivarName)
        try container.encode(type, forKey: .type)
        try container.encode(isExplicit, forKey: .isExplicit)
        
        try super.encode(to: container.superEncoder())
    }
    
    public enum SynthesizeType: String, Codable {
        case synthesize
        case dynamic
    }
    
    private enum CodingKeys: String, CodingKey {
        case propertyName
        case ivarName
        case type
        case isExplicit
    }
}
