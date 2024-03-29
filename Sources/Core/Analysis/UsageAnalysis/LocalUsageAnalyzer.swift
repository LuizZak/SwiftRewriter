import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// Usage analyzer that specializes in lookup of usages of locals within function
/// bodies.
public class LocalUsageAnalyzer: BaseUsageAnalyzer, LocalUsageAnalyzerType {

    public override init(typeSystem: TypeSystem) {
        super.init(typeSystem: typeSystem)
    }

    public func findDefinitionOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> LocalCodeDefinition? {

        guard let scope = syntaxNode.nearestScope else {
            return nil
        }

        if let def = scope.firstDefinition(named: local) as? LocalCodeDefinition {
            return def
        }

        return nil
    }
    
    public func findUsagesOf(
        localNamed local: String,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage] {
        
        var usages: [DefinitionUsage] = []
        
        let visitor =
            AnonymousSyntaxNodeVisitor { node in
                guard let identifier = node as? IdentifierExpression else {
                    return
                }
                guard let def = identifier.definition as? LocalCodeDefinition else {
                    return
                }
                
                if def.name == local {
                    let usageKind = self.usageKindContext(identifier)
                    
                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: def,
                            expression: .identifier(identifier),
                            usageKind: usageKind
                        )
                    
                    usages.append(usage)
                }
            }
        
        container.accept(visitor)
        
        return usages
    }
    
    public func findUsagesOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage] {
        
        guard let definition = findDefinitionOf(localNamed: local, inScopeOf: syntaxNode) else {
            return []
        }
        
        return findUsagesOf(definition: definition, in: container, intention: intention)
    }
    
    public func findUsagesOf(
        definition: LocalCodeDefinition,
        in container: StatementContainer,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage] {
        
        var usages: [DefinitionUsage] = []
        
        let visitor =
            AnonymousSyntaxNodeVisitor { node in
                guard let identifier = node as? IdentifierExpression else {
                    return
                }
                
                guard let def = identifier.definition as? LocalCodeDefinition else {
                    return
                }
                
                guard def == definition else {
                    return
                }
                
                let usageKind = self.usageKindContext(identifier)
                
                let usage =
                    DefinitionUsage(
                        intention: intention,
                        definition: def,
                        expression: .identifier(identifier),
                        usageKind: usageKind
                    )
                
                usages.append(usage)
            }
        
        container.accept(visitor)
        
        return usages
    }
    
    public func findAllUsages(
        in syntaxNode: SyntaxNode,
        intention: FunctionBodyCarryingIntention?
    ) -> [DefinitionUsage] {
        
        var usages: [DefinitionUsage] = []
        
        let visitor =
            AnonymousSyntaxNodeVisitor { node in
                guard let identifier = node as? IdentifierExpression else {
                    return
                }
                guard let definition = identifier.definition else {
                    return
                }
                
                let usageKind = self.usageKindContext(identifier)
                
                let usage =
                    DefinitionUsage(
                        intention: intention,
                        definition: definition,
                        expression: .identifier(identifier),
                        usageKind: usageKind
                    )
                
                usages.append(usage)
            }
        
        switch syntaxNode {
        case let stmt as Statement:
            visitor.visitStatement(stmt)
            
        case let exp as Expression:
            visitor.visitExpression(exp)
            
        default:
            fatalError("Cannot search for definitions in statement node of type \(type(of: syntaxNode))")
        }
        
        return usages
    }
    
    public func findDefinitionOf(
        localNamed local: String,
        inScopeOf syntaxNode: SyntaxNode
    ) -> LocalCodeDefinition? {

        let scope = scopeFor(syntaxNode: syntaxNode)
        
        return scope?.firstDefinition(named: local) as? LocalCodeDefinition
    }
    
    private func scopeFor(syntaxNode: SyntaxNode) -> CodeScope? {
        if let statement = syntaxNode as? Statement {
            return statement.nearestScope
        }
        if let statement = syntaxNode.firstAncestor(ofType: Statement.self) {
            return scopeFor(syntaxNode: statement)
        }
        
        fatalError("Unknown syntax node type \(type(of: syntaxNode)) with no \(Statement.self)-typed parent node!")
    }
}
