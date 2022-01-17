import SwiftAST
import KnownType
import Intentions
import TypeSystem

public class BaseUsageAnalyzer: UsageAnalyzer {
    var typeSystem: TypeSystem
    
    init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }
    
    public func findUsagesOf(method: KnownMethod) -> [DefinitionUsage] {
        let containers = statementContainers()
        
        var usages: [DefinitionUsage] = []
        
        for (container, intention) in containers {
            let visitor = AnonymousSyntaxNodeVisitor { node in
                guard let exp = node as? PostfixExpression else {
                    return
                }
                guard let member = exp.member else {
                    return
                }
                guard let expMethod = member.memberDefinition as? KnownMethod else {
                    return
                }
                guard expMethod.signature == method.signature else {
                    return
                }
                guard expMethod.ownerType?.asTypeName == method.ownerType?.asTypeName else {
                    return
                }

                // Attempt to infer usage of a function call, for context purposes.
                var expressionKind: DefinitionUsage.ExpressionKind
                expressionKind = .memberAccess(exp.exp, member, in: exp)

                if let parent = exp.parentExpression?.asPostfix {
                    if let functionCall = parent.op.asFunctionCall {
                        expressionKind = .functionCall(exp, functionCall, in: parent)
                    }
                }

                let usage =
                    DefinitionUsage(
                        intention: intention,
                        definition: .forKnownMember(method),
                        expression: expressionKind,
                        isReadOnlyUsage: true
                    )
                
                usages.append(usage)
            }
            
            switch container {
            case .function(let body):
                visitor.visitStatement(body.body)
            case .expression(let exp):
                visitor.visitExpression(exp)
            case .statement(let stmt):
                visitor.visitStatement(stmt)
            }
        }
        
        return usages
    }
    
    public func findUsagesOf(property: KnownProperty) -> [DefinitionUsage] {
        let containers = statementContainers()
        
        var usages: [DefinitionUsage] = []
        
        for (container, intention) in containers {
            let visitor = AnonymousSyntaxNodeVisitor { node in
                guard let exp = node as? PostfixExpression else {
                    return
                }
                guard let member = exp.member else {
                    return
                }
                guard let expProperty = member.memberDefinition as? KnownProperty else {
                    return
                }
                guard expProperty.name == property.name else {
                    return
                }
                
                if expProperty.ownerType?.asTypeName == property.ownerType?.asTypeName {
                    let readOnly = self.isReadOnlyContext(exp)
                    
                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: .forKnownMember(property),
                            expression: .memberAccess(exp.exp, member, in: exp),
                            isReadOnlyUsage: readOnly
                        )
                    
                    usages.append(usage)
                }
            }
            
            switch container {
            case .function(let body):
                visitor.visitStatement(body.body)
            case .expression(let exp):
                visitor.visitExpression(exp)
            case .statement(let stmt):
                visitor.visitStatement(stmt)
            }
        }
        
        return usages
    }
    
    func isReadOnlyContext(_ expression: Expression) -> Bool {
        // TODO: Reduce duplication of this code here and in ExpressionTypeResolver

        if let assignment = expression.parentExpression?.asAssignment {
            return expression !== assignment.lhs
        }
        // Unary '&' is interpreted as 'address-of', which is a mutable operation.
        if let unary = expression.parentExpression?.asUnary {
            return unary.op != .bitwiseAnd
        }
        if let postfix = expression.parentExpression?.asPostfix, expression == postfix.exp {
            let root = postfix.topPostfixExpression
            
            // If at any point we find a function call, the original value cannot
            // be mutated due to any change on the returned value, so we just
            // assume it's never written.
            let chain = PostfixChainInverter.invert(expression: root)
            if let call = chain.first(where: { $0.postfix is FunctionCallPostfix }),
                let member = call.postfixExpression?.exp.asPostfix?.member {
                
                // Skip checking mutating methods on reference types, since those
                // don't mutate variables.
                if let type = chain.first?.expression?.resolvedType,
                    !typeSystem.isScalarType(type) {
                    
                    return true
                }
                
                if let method = member.memberDefinition as? KnownMethod {
                    return !method.signature.isMutating
                }
                
                return true
            }
            
            // Writing to a reference type at any point invalidates mutations
            // to the original value.
            let types = chain.compactMap(\.resolvedType)
            if types.contains(where: { typeSystem.isClassInstanceType($0) }) {
                return true
            }
            
            return isReadOnlyContext(root)
        }
        
        return true
    }
    
    func statementContainers() -> [(StatementContainer, FunctionBodyCarryingIntention)] {
        []
    }
}
