import ObjcParserAntlr
import Antlr4

/// A parser rule that defines a declaration with a scope.
public protocol DeclarationParserRule { }

public extension Contextable where Base: DeclarationParserRule {
    var scope: ContainmentScope {
        var parent = base.getParent()
        while let p = parent {
            if p is ObjectiveCParser.CompoundStatementContext {
                return .local
            }
            if p is ObjectiveCParser.InterfaceDeclarationListContext ||
                p is ObjectiveCParser.ImplementationDefinitionListContext ||
                p is ObjectiveCParser.ProtocolDeclarationListContext {
                return .class
            }
            
            parent = p.getParent()
        }
        
        return .global
    }
    
    /// Describes the contained scope of a declaration
    enum ContainmentScope {
        case global
        case `class`
        case local
    }
}

public extension Contextable where Base: ObjectiveCParser.VarDeclarationContext {
    /// Whether this declaration represents a static variable declaration
    var isStatic: Bool {
        guard let specs = base.declarationSpecifiers()?.storageClassSpecifier() else {
            return false
        }
        
        return specs.contains(where: { $0.STATIC() != nil })
    }
}

extension ObjectiveCParser.VarDeclarationContext: DeclarationParserRule { }
extension ObjectiveCParser.FunctionDefinitionContext: DeclarationParserRule { }
