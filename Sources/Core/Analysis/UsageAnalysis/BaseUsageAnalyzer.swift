import SwiftAST
import KnownType
import Intentions
import TypeSystem

public class BaseUsageAnalyzer: UsageAnalyzer {
    var typeSystem: TypeSystem
    
    init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }

    public func findUsagesOf(function: GlobalFunctionGenerationIntention) -> [DefinitionUsage] {
        let containers = statementContainers()
        
        var usages: [DefinitionUsage] = []

        for (container, intention) in containers {
            let visitor = AnonymousSyntaxNodeVisitor { node in
                guard let exp = node as? IdentifierExpression else {
                    return
                }
                guard let definition = exp.definition as? GlobalIntentionCodeDefinition else {
                    return
                }
                guard definition.intention === function else {
                    return
                }

                // Attempt to infer usage of a function call, for context purposes.
                var expressionKind: DefinitionUsage.ExpressionKind
                expressionKind = .identifier(exp)

                if let parent = exp.parentExpression?.asPostfix {
                    if let functionCall = parent.op.asFunctionCall {
                        expressionKind = .functionCall(exp, functionCall, in: parent)
                    }
                }

                let usage =
                    DefinitionUsage(
                        intention: intention,
                        definition: .forGlobalFunction(function),
                        expression: expressionKind,
                        usageKind: .readOnly
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
                guard let expMethod = member.definition as? KnownMethod else {
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
                        usageKind: .readOnly
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
                guard let expProperty = member.definition as? KnownProperty else {
                    return
                }
                guard expProperty.name == property.name else {
                    return
                }
                
                if expProperty.ownerType?.asTypeName == property.ownerType?.asTypeName {
                    let usageKind = self.usageKindContext(exp)
                    
                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: .forKnownMember(property),
                            expression: .memberAccess(exp.exp, member, in: exp),
                            usageKind: usageKind
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
    
    public func findUsagesOf(subscript sub: KnownSubscript) -> [DefinitionUsage] {
        let containers = statementContainers()
        
        var usages: [DefinitionUsage] = []
        
        for (container, intention) in containers {
            let visitor = AnonymousSyntaxNodeVisitor { node in
                guard let exp = node as? PostfixExpression else {
                    return
                }
                guard let subExp = exp.subscription else {
                    return
                }
                guard let expMethod = subExp.definition as? KnownSubscript else {
                    return
                }
                guard expMethod.parameters == sub.parameters else {
                    return
                }
                guard expMethod.ownerType?.asTypeName == sub.ownerType?.asTypeName else {
                    return
                }

                let usage =
                    DefinitionUsage(
                        intention: intention,
                        definition: .forKnownMember(sub),
                        expression: .subscript(exp.exp, subExp, in: exp),
                        usageKind: .readOnly
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
    
    /// Returns an array of all usages found within a given syntax node tree.
    public func findAllUsagesIn(_ syntaxNode: SyntaxNode, intention: FunctionBodyCarryingIntention) -> [DefinitionUsage] {
        var usages: [DefinitionUsage] = []

        func pushDefinition(_ newUsage: DefinitionUsage) {
            // Avoid double-definition usages
            for usage in usages {
                if usage.expression.expression == newUsage.expression.expression {
                    return
                }
            }

            usages.append(newUsage)
        }
        
        let visitor = AnonymousSyntaxNodeVisitor { node in
            if let exp = node as? PostfixExpression {
                if let member = exp.member {
                    // Property/field definition
                    if let expProperty = member.definition {
                        let usageKind = self.usageKindContext(exp)
                                        
                        let usage =
                            DefinitionUsage(
                                intention: intention,
                                definition: .forKnownMember(expProperty),
                                expression: .memberAccess(exp.exp, member, in: exp),
                                usageKind: usageKind
                            )
                        
                        pushDefinition(usage)
                    }
                } else if let sub = exp.subscription {
                    // Subscript member definition
                    if let expSub = sub.definition {
                        let usageKind = self.usageKindContext(exp)
                                        
                        let usage =
                            DefinitionUsage(
                                intention: intention,
                                definition: .forKnownMember(expSub),
                                expression: .subscript(exp.exp, sub, in: exp),
                                usageKind: usageKind
                            )
                        
                        pushDefinition(usage)
                    }
                } else if let call = exp.functionCall {
                    // Callable member definition
                    if let expCall = call.definition {
                        let usageKind = self.usageKindContext(exp)
                                        
                        let usage =
                            DefinitionUsage(
                                intention: intention,
                                definition: .forKnownMember(expCall),
                                expression: .functionCall(exp, call, in: exp),
                                usageKind: usageKind
                            )
                        
                        pushDefinition(usage)
                    }
                }
            }

            // Identifier-based access
            if let exp = node as? IdentifierExpression, exp.definition != nil {
                // Global function
                if
                    let definition = exp.definition as? GlobalIntentionCodeDefinition,
                    let globalFunc = definition.intention as? GlobalFunctionGenerationIntention
                {
                    // Attempt to infer usage of a function call, for context purposes.
                    var expressionKind: DefinitionUsage.ExpressionKind
                    expressionKind = .identifier(exp)

                    if let parent = exp.parentExpression?.asPostfix {
                        if let functionCall = parent.op.asFunctionCall {
                            expressionKind = .functionCall(exp, functionCall, in: parent)
                        }
                    }

                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: .forGlobalFunction(globalFunc),
                            expression: expressionKind,
                            usageKind: .readOnly
                        )
                    
                    pushDefinition(usage)
                }

                // Global variable
                if
                    let definition = exp.definition as? GlobalIntentionCodeDefinition,
                    let globalVar = definition.intention as? GlobalVariableGenerationIntention
                {
                    let usage =
                        DefinitionUsage(
                            intention: intention,
                            definition: .forGlobalVariable(globalVar),
                            expression: .identifier(exp),
                            usageKind: .readOnly
                        )
                    
                    pushDefinition(usage)
                }
            }
        }

        switch syntaxNode {
        case let expr as Expression:
            expr.accept(visitor)
        
        case let stmt as Statement:
            stmt.accept(visitor)

        default:
            break
        }
        
        return usages
    }
    
    func usageKindContext(_ expression: Expression) -> DefinitionUsage.UsageKind {
        // TODO: Reduce duplication of this code here and in ExpressionTypeResolver

        if let assignment = expression.parentExpression?.asAssignment {
            guard expression === assignment.lhs else {
                return .readOnly
            }

            return usageForAssignmentOperator(assignment.op)
        }

        // Unary '&' is interpreted as 'address-of', which is a read/write mutable
        // operation.
        if let unary = expression.parentExpression?.asUnary {
            return unary.op == .bitwiseAnd ? .readWrite : .readOnly
        }

        if let postfix = expression.parentExpression?.asPostfix, expression == postfix.exp {
            let root = postfix.topPostfixExpression
            
            // If at any point we find a function call, the original value cannot
            // be mutated due to any change on the returned value, so we just
            // assume it's never written.
            let chain = PostfixChainInverter.invert(expression: root)

            if
                let call = chain.first(where: { $0.postfix is FunctionCallPostfix }),
                let member = call.postfixExpression?.exp.asPostfix?.member
            {
                
                // Skip checking mutating methods on reference types, since those
                // don't mutate variables.
                if let type = chain.first?.expression?.resolvedType,
                    !typeSystem.isScalarType(type) {
                    
                    return .readOnly
                }
                
                if let method = member.definition as? KnownMethod {
                    return method.signature.isMutating ? .readWrite : .readOnly
                }
                
                return .readOnly
            }
            
            // Writing to a reference type at any point invalidates mutations
            // to the original value.
            let types = chain.compactMap(\.resolvedType)
            if types.contains(where: { typeSystem.isClassInstanceType($0) }) {
                return .readOnly
            }
            
            return usageKindContext(root)
        }
        
        return .readOnly
    }

    private func usageForAssignmentOperator(_ op: SwiftOperator) -> DefinitionUsage.UsageKind {
        guard op.category == .assignment else {
            return .readOnly
        }

        return op == .assign ? .writeOnly : .readWrite
    }
    
    func statementContainers() -> [(StatementContainer, FunctionBodyCarryingIntention)] {
        []
    }
}
