import GrammarModels
import SwiftAST

/// An intention to generate a class extension from an existing class
public final class ClassExtensionGenerationIntention: BaseClassIntention {
    /// Original Objective-C category name that originated this category.
    public var categoryName: String?
    
    public override var isExtension: Bool {
        return true
    }
    
    public override init(typeName: String,
                         accessLevel: AccessLevel = .internal,
                         source: ASTNode? = nil) {
        
        super.init(typeName: typeName,
                   accessLevel: accessLevel,
                   source: source)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        categoryName = try container.decode(String.self, forKey: .categoryName)
        
        try super.init(from: container.superDecoder())
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(categoryName, forKey: .categoryName)
        
        try super.encode(to: container.superEncoder())
    }
    
    private enum CodingKeys: String, CodingKey {
        case categoryName
    }
}
