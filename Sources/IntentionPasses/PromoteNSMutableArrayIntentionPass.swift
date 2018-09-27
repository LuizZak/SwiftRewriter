import SwiftAST
import Intentions
import KnownType
import SwiftRewriterLib

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
            
            if let baseClass = type as? BaseClassIntention {
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
                                             typeSystem: context.typeSystem)
        
        let property: KnownProperty
        
        switch entry.source {
        case .field(let field):
            property = field
        case .property(let p):
            property = p
        }
        
        let usages = usageAnalyzer.findUsagesOf(property: property)

        if usages.contains(where: isStrictNSMutableArrayUsage) {
            return
        }
        
        // Analysis passed! Switch type of array, now.
        
        
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
    
    /// Returns `true` if a given usage cannot be replaced by a `Array<T>`, due
    /// to expectations of a type being an `NSMutableArray`.
    ///
    /// This is a conservative check that returns `true` in case the usage cannot
    /// be verified as being a pure `Array<T>`-like usage.
    private func isStrictNSMutableArrayUsage(_ usage: DefinitionUsage) -> Bool {
        if !usage.isReadOnlyUsage {
            if usage.expression.parentExpression?.asAssignment?.lhs === usage.expression {
                return false
            }
            
            return true
        }
        
        if let expectedType = usage.expression.expectedType {
            if isNSArray(expectedType) || isArray(expectedType) {
                return false
            }
            
            return true
        }
        
        return false
    }
    
    private func convertPostfixInvocation(_ exp: Expression) -> Expression {
        return exp
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
        case .array,
             .nominal(.generic("Array", _)):
            
            return true
        default:
            return false
        }
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
