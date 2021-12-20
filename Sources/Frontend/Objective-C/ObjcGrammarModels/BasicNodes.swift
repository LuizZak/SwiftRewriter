import Utils
import GrammarModelBase

/// A node that represents the global namespace
public final class GlobalContextNode: ObjcASTNode, ObjcInitializableNode {
    public var functionDefinitions: [ObjcFunctionDefinition] {
        childrenMatching()
    }
    public var variableDeclarations: [ObjcVariableDeclaration] {
        childrenMatching()
    }
    public var classInterfaces: [ObjcClassInterface] {
        childrenMatching()
    }
    public var classImplementations: [ObjcClassImplementation] {
        childrenMatching()
    }
    public var categoryInterfaces: [ObjcClassCategoryInterface] {
        childrenMatching()
    }
    public var categoryImplementations: [ObjcClassCategoryImplementation] {
        childrenMatching()
    }
    public var protocolDeclarations: [ObjcProtocolDeclaration] {
        childrenMatching()
    }
    public var typedefNodes: [ObjcTypedefNode] {
        childrenMatching()
    }
    public var enumDeclarations: [ObjcEnumDeclaration] {
        childrenMatching()
    }
    
    public required init(isInNonnullContext: Bool) {
        super.init(isInNonnullContext: isInNonnullContext)
    }
}

/// A node with no proper type.
public class UnknownNode: ObjcASTNode {
    
}

/// An identifier node
public class Identifier: ObjcASTNode {
    /// String identifier
    public var name: String
    
    public override var shortDescription: String {
        name
    }
    
    public init(name: String,
                isInNonnullContext: Bool,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero) {
        
        self.name = name
        
        super.init(isInNonnullContext: isInNonnullContext,
                   location: location,
                   length: length)
    }
}

/// A node that represents a special keyword-type token
public class KeywordNode: ObjcASTNode {
    public var keyword: ObjcKeyword
    
    public override var shortDescription: String {
        keyword.rawValue
    }
    
    public init(keyword: ObjcKeyword,
                isInNonnullContext: Bool,
                location: SourceLocation = .invalid,
                length: SourceLength = .zero) {
        
        self.keyword = keyword
        
        super.init(isInNonnullContext: isInNonnullContext,
                   location: location,
                   length: length)
    }
}
