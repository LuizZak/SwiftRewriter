import SwiftAST
import Commons
import Intentions
import KnownType
import Analysis

/// Intention pass that analyzes all usages of `NSMutableArray` to promote usages
/// that can safely be converted to `Array<T>`.
public class PromoteNSMutableArrayIntentionPass: IntentionPass {
    private let tag = "\(PromoteNSMutableArrayIntentionPass.self)"
    
    var intentions: IntentionCollection!
    var context: IntentionPassContext!
    
    public init() {
        
    }
    
    public func apply(on intentionCollection: IntentionCollection,
                      context: IntentionPassContext) {
        
        intentions = intentionCollection
        self.context = context
        
        let entries = collectAnalysisEntries(in: intentionCollection)
        
        applyAnalysis(to: entries)
    }
    
    private func collectAnalysisEntries(in intentionCollection: IntentionCollection) -> [AnalysisEntry] {
        var entries: [AnalysisEntry] = []
        
        let types = intentionCollection.typeIntentions()
        
        for type in types {
            for property in type.properties {
                if let arrayType = arrayTypeForNSMutableArray(property.type) {
                    let entry =
                        AnalysisEntry(type: type,
                                      source: .property(property),
                                      arrayType: arrayType)
                    
                    entries.append(entry)
                }
            }
            
            if let baseClass = type as? InstanceVariableContainerIntention {
                for field in baseClass.instanceVariables {
                    if let arrayType = arrayTypeForNSMutableArray(field.type) {
                        let entry =
                            AnalysisEntry(type: type,
                                          source: .field(field),
                                          arrayType: arrayType)
                        
                        entries.append(entry)
                    }
                }
            }
        }
        
        return entries
    }
    
    private func applyAnalysis(to entries: [AnalysisEntry]) {
        for entry in entries {
            applyAnalysis(to: entry)
        }
    }
    
    private func applyAnalysis(to entry: AnalysisEntry) {
        let usageAnalyzer =
            IntentionCollectionUsageAnalyzer(intentions: intentions,
                                             typeSystem: context.typeSystem,
                                             numThreads: context.numThreads)
        
        let property: KnownProperty
        
        switch entry.source {
        case .field(let field):
            property = field
        case .property(let p):
            property = p
        }
        
        let usages = usageAnalyzer.findUsagesOf(property: property)

        if !usages.allSatisfy(isArrayOfTReplaceableUsage) {
            return
        }
        
        // Analysis passed! Switch type of array, now.
        // FIXME: Should switch usages of member types of `NSMutableArray`s (e.g.
        // `add()`, `index(of:)`, etc.) to the equivalent member types of
        // `Array<T>`
        
        let typeName = context.typeMapper.typeNameString(for: entry.arrayType)
        
        let description = """
            Promoting type from NSMutableArray<\(typeName)> to Array<\(typeName)> \
            due to all usage sites being compatible
            """
        
        switch entry.source {
        case .field(let field):
            field.storage.type = SwiftType.array(entry.arrayType)
            
            field.history.recordChange(tag: tag, description: description)
            
        case .property(let property):
            property.storage.type = SwiftType.array(entry.arrayType)
            
            property.history.recordChange(tag: tag, description: description)
        }
    }
    
    /// Returns `true` if a given usage can be replaced by a `Array<T>`, returning
    /// `false` otherwise due to expectations of a type being an `NSMutableArray`.
    ///
    /// This is a conservative check that returns `false` in case the usage cannot
    /// be verified as being a pure `Array<T>`-like usage.
    private func isArrayOfTReplaceableUsage(_ usage: DefinitionUsage) -> Bool {
        if !usage.isReadOnlyUsage {
            if usage.expression.parentExpression?.asAssignment?.lhs === usage.expression {
                return true
            }
            
            return false
        }
        
        if let expectedType = usage.expression.expectedType {
            if isNSArray(expectedType) || isArray(expectedType) {
                return true
            }
            
            return false
        } else if usage.expression.isErrorTyped {
            return false
        }
        
        // Check if we have a properly typed expression, and check if the usage
        // references an extension that is exclusively for NSArray or NSMutableArray
        guard let postfix = postfixExpression(usage.expression) else {
            return false
        }
        
        let inverted = PostfixChainInverter.invert(expression: postfix)
        
        for (i, postfixChainItem) in inverted.enumerated() {
            guard let op = postfixChainItem.postfix else {
                continue
            }
            guard let member = op.asMember else {
                continue
            }
            
            // Check if we have an aliased NSArray/NSMutableArray method created
            // by a method annotated with `@_swiftrewriter` here
            if i < inverted.count - 1 && member.memberDefinition == nil {
                guard let identifier = postfixChainItem.formFunctionIdentifier(withNext: inverted[i + 1]) else {
                    continue
                }
                
                // TODO: Maybe we shouldn't really be looking at types directly
                // from compound types, but through a first-class support for
                // alised members in `TypeSystem`?
                let nsArray = FoundationCompoundTypes.nsArray.create()
                let nsMutArray = FoundationCompoundTypes.nsMutableArray.create()
                
                if nsArray.aliasedMethods.containsMethod(withIdentifier: identifier) {
                    return true
                }
                if nsMutArray.aliasedMethods.containsMethod(withIdentifier: identifier) {
                    return true
                }
            }
            
            guard let memberIntention = member.memberDefinition as? MemberGenerationIntention else {
                continue
            }
            guard let memberType = memberIntention.type else {
                return false
            }
            
            guard let type = context.typeSystem.knownTypeWithName(memberType.typeName) else {
                return false
            }
            
            if memberType.isExtension && (type.typeName == "NSMutableArray" || type.typeName == "NSArray") {
                return false
            }
        }
        
        return true
    }
    
    /// Returns `true` iff `member` represents a member access of a method or property
    /// of native NSMutableArray/NSArrays.
    private func isMemberAccessOfNSMutableArrayOrArrayDefinition(_ member: MemberPostfix) -> Bool {
        guard let memberType = member.memberDefinition?.ownerType else {
            return false
        }
        
        let memberTypeName = memberType.asTypeName
        guard let type = context.typeSystem.knownTypeWithName(memberTypeName) else {
            return false
        }
        
        if type.isExtension && (type.typeName == "NSMutableArray" || type.typeName == "NSArray") {
            return false
        }
        
        return true
    }
    
    private func arrayTypeForNSMutableArray(_ type: SwiftType) -> SwiftType? {
        switch context.typeSystem.resolveAlias(in: type.deepUnwrapped).deepUnwrapped {
        case .nominal(.generic("NSMutableArray", let types)) where types.count == 1:
            return types[0]
        default:
            return nil
        }
    }
    
    private func isNSArray(_ type: SwiftType) -> Bool {
        switch context.typeSystem.resolveAlias(in: type.deepUnwrapped).deepUnwrapped {
        case .nominal(.generic("NSArray", _)),
             .nominal(.typeName("NSArray")):
            return true
            
        default:
            return false
        }
    }
    
    private func isArray(_ type: SwiftType) -> Bool {
        switch context.typeSystem.resolveAlias(in: type.deepUnwrapped).deepUnwrapped {
        case .nominal(.generic("Array", _)):
            
            return true
        default:
            return false
        }
    }
    
    private func postfixExpression(_ exp: Expression) -> PostfixExpression? {
        guard let postfix = exp.parentExpression?.asPostfix else {
            return exp.asPostfix
        }
        
        return postfix.exp === exp ? postfixExpression(postfix) : nil
    }
}

private struct AnalysisEntry {
    var type: TypeGenerationIntention
    var source: Source
    var arrayType: SwiftType
    
    enum Source {
        case property(PropertyGenerationIntention)
        case field(InstanceVariableGenerationIntention)
    }
}

private extension Sequence where Element == KnownMethod {
    func containsMethod(withIdentifier identifier: FunctionIdentifier) -> Bool {
        return contains(where: { $0.signature.asIdentifier == identifier })
    }
}
