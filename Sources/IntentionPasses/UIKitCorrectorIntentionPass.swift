import SwiftAST
import SwiftRewriterLib
import Commons

/// Makes correction for signatures of subclasses and conformeds of known UIKit
/// classes and protocols
public class UIKitCorrectorIntentionPass: ClassVisitingIntentionPass {
    private var historyTag = "\(UIKitCorrectorIntentionPass.self)"
    
    private var conversions: [SignatureConversion] = []
    
    public override init() {
        super.init()
        
        createConversions()
    }
    
    fileprivate func addCompoundedTypeMapping(_ compoundedType: CompoundedMappingType) {
        let mappings = compoundedType.signatureMappings
        
        conversions.append(contentsOf:
            mappings.map {
                SignatureConversion(
                    relationship: .subtype(compoundedType.typeName),
                    signatureMapper: $0,
                    adjustNullability: true
                )
            }
        )
    }
    
    func createConversions() {
        addCompoundedTypeMapping(UIViewCompoundType.create())
        addCompoundedTypeMapping(UIGestureRecognizerCompoundType.create())
        
        addConversions(
            .conformance(protocolName: "UITableViewDelegate"),
            keywordPairs: [
                (["tableView", nil, "willDisplayCell", "forRowAtIndexPath"], ["tableView", nil, "willDisplay", "forRowAt"]),
                (["tableView", nil, "didEndDisplayingCell", "forRowAtIndexPath"], ["tableView", nil, "didEndDisplaying", "forRowAt"]),
                (["tableView", nil, "heightForRowAtIndexPath"], ["tableView", nil, "heightForRowAt"]),
                (["tableView", nil, "estimatedHeightForRowAtIndexPath"], ["tableView", nil, "estimatedHeightForRowAt"]),
                (["tableView", nil, "accessoryButtonTappedForRowWithIndexPath"], ["tableView", nil, "accessoryButtonTappedForRowWith"]),
                (["tableView", nil, "shouldHighlightRowAtIndexPath"], ["tableView", nil, "shouldHighlightRowAt"]),
                (["tableView", nil, "didHighlightRowAtIndexPath"], ["tableView", nil, "didHighlightRowAt"]),
                (["tableView", nil, "didUnhighlightRowAtIndexPath"], ["tableView", nil, "didUnhighlightRowAt"]),
                (["tableView", nil, "willSelectRowAtIndexPath"], ["tableView", nil, "willSelectRowAt"]),
                (["tableView", nil, "willDeselectRowAtIndexPath"], ["tableView", nil, "willDeselectRowAt"]),
                (["tableView", nil, "didSelectRowAtIndexPath"], ["tableView", nil, "didSelectRowAt"]),
                (["tableView", nil, "didDeselectRowAtIndexPath"], ["tableView", nil, "didDeselectRowAt"]),
                (["tableView", nil, "editingStyleForRowAtIndexPath"], ["tableView", nil, "editingStyleForRowAt"]),
                (["tableView", nil, "titleForDeleteConfirmationButtonForRowAtIndexPath"], ["tableView", nil, "titleForDeleteConfirmationButtonForRowAt"]),
                (["tableView", nil, "editActionsForRowAtIndexPath"], ["tableView", nil, "editActionsForRowAt"]),
                (["tableView", nil, "leadingSwipeActionsConfigurationForRowAtIndexPath"], ["tableView", nil, "leadingSwipeActionsConfigurationForRowAt"]),
                (["tableView", nil, "trailingSwipeActionsConfigurationForRowAtIndexPath"], ["tableView", nil, "trailingSwipeActionsConfigurationForRowAt"]),
                (["tableView", nil, "shouldIndentWhileEditingRowAtIndexPath"], ["tableView", nil, "shouldIndentWhileEditingRowAt"]),
                (["tableView", nil, "willBeginEditingRowAtIndexPath"], ["tableView", nil, "willBeginEditingRowAt"]),
                (["tableView", nil, "didEndEditingRowAtIndexPath"], ["tableView", nil, "didEndEditingRowAt"]),
                (["tableView", nil, "targetIndexPathForMoveFromRowAtIndexPath", "toProposedIndexPath"], ["tableView", nil, "targetIndexPathForMoveFromRowAt", "toProposedIndexPath"]),
                (["tableView", nil, "indentationLevelForRowAtIndexPath"], ["tableView", nil, "indentationLevelForRowAt"]),
                (["tableView", nil, "shouldShowMenuForRowAtIndexPath"], ["tableView", nil, "shouldShowMenuForRowAt"]),
                (["tableView", nil, "canPerformAction", "forRowAtIndexPath", "withSender"], ["tableView", nil, "canPerformAction", "forRowAt", "withSender"]),
                (["tableView", nil, "performAction", "forRowAtIndexPath", "withSender"], ["tableView", nil, "performAction", "forRowAt", "withSender"]),
                (["tableView", nil, "canFocusRowAtIndexPath"], ["tableView", nil, "canFocusRowAt"]),
                (["tableView", nil, "shouldUpdateFocusInContext"], ["tableView", nil, "shouldUpdateFocusIn"]),
                (["tableView", nil, "didUpdateFocusInContext", "withAnimationCoordinator"], ["tableView", nil, "didUpdateFocusIn", "with"]),
                (["indexPathForPreferredFocusedViewInTableView", nil], ["indexPathForPreferredFocusedView", "in"]),
                (["tableView", nil, "shouldSpringLoadRowAtIndexPath", "withContext"], ["tableView", nil, "shouldSpringLoadRowAt", "with"]),
            ])
        
        // UITableViewDataSource
        addConversions(
            .conformance(protocolName: "UITableViewDataSource"),
            keywordPairs: [
                (["tableView", nil, "cellForRowAtIndexPath"], ["tableView", nil, "cellForRowAt"]),
                (["numberOfSectionsInTableView", nil], ["numberOfSections", "in"]),
                (["tableView", nil, "canEditRowAtIndexPath"], ["tableView", nil, "canEditRowAt"]),
                (["tableView", nil, "canMoveRowAtIndexPath"], ["tableView", nil, "canMoveRowAt"]),
                (["sectionIndexTitlesForTableView", nil], ["sectionIndexTitles", "for"]),
                (["tableView", nil, "sectionForSectionIndexTitle", "atIndex"], ["tableView", nil, "sectionForSectionIndexTitle", "at"]),
                (["tableView", nil, "commitEditingStyle", "forRowAtIndexPath"], ["tableView", nil, "commit", "forRowAt"]),
                (["tableView", nil, "moveRowAtIndexPath", "toIndexPath"], ["tableView", nil, "moveRowAt", "to"])
            ])
    }
    
    private func addConversion(_ relationship: SignatureConversion.Relationship,
                               fromKeywords k1: [String?], to k2: [String?]) {
        
        let functionSignature1 =
            FunctionSignature(name: k1[0] ?? "__",
                              parameters: k1.dropFirst().map { ParameterSignature(label: $0, name: $0 ?? "_", type: .any) },
                              returnType: .any,
                              isStatic: false)
        
        let functionSignature2 =
            FunctionSignature(name: k2[0] ?? "__",
                              parameters: k2.dropFirst().map { ParameterSignature(label: $0, name: $0 ?? "_", type: .any) },
                              returnType: .any,
                              isStatic: false)
        
        conversions.append(
            SignatureConversion(
                relationship: relationship,
                from: functionSignature1,
                to: functionSignature2,
                adjustNullability: false
            )
        )
    }
    
    private func addConversions(_ relationship: SignatureConversion.Relationship,
                                keywordPairs: [([String?], [String?])]) {
        
        for pair in keywordPairs {
            addConversion(relationship, fromKeywords: pair.0, to: pair.1)
        }
        
    }
    
    override func applyOnMethod(_ method: MethodGenerationIntention) {
        guard let type = method.type as? ClassGenerationIntention else {
            return
        }
        
        for conversion in conversions where conversion.canApply(to: method.signature) {
            let isProtocol: Bool
            // Check relationship matches
            switch conversion.relationship {
            case .subtype(let typeName):
                if !context.typeSystem.isType(type.typeName, subtypeOf: typeName) {
                    continue
                }
                
                isProtocol = false
                
            case .conformance(let protocolName):
                if !context.typeSystem.isType(type.typeName, conformingTo: protocolName) {
                    continue
                }
                
                isProtocol = true
            }
            
            let oldSignature = method.signature
            
            if !conversion.apply(to: &method.signature) {
                continue
            }
            
            // Mark as override, in case of subtype relationship
            if !isProtocol {
                method.isOverride = true
            }
            
            let typeName = conversion.relationship.typeName
            method.history.recordChange(
                tag: historyTag,
                description: """
                Replaced signature of \(isProtocol ? "implementer" : "override") method \
                of \(typeName).\(TypeFormatter.asString(signature: method.signature, includeName: true)) \
                from old signature \(typeName).\(TypeFormatter.asString(signature: oldSignature, includeName: true)).
                """
            )
            
            notifyChange()
            
            return
        }
    }
}

private class SignatureConversion {
    let relationship: Relationship
    let from: FunctionSignature
    let to: FunctionSignature
    let adjustNullability: Bool
    
    /// Creates a new `SignatureConversion` instance with a given source and target
    /// signatures to convert.
    ///
    /// Count of keywords on both signatures must match (i.e. cannot change the
    /// number of arguments of a method)
    ///
    /// If `adjustNullability == true`, parameter and return types will be inspected
    /// and nullability annotations will be matched on the target method signature.
    ///
    /// - precondition: `from.count == to.count`
    /// - precondition: `!from.isEmpty`
    public init(relationship: Relationship,
                from: FunctionSignature,
                to: FunctionSignature,
                adjustNullability: Bool) {
        
        precondition(from.parameters.count == to.parameters.count,
                     "from.parameters.count == to.parameters.count")
        precondition(!from.parameters.isEmpty,
                     "!from.parameters.isEmpty")
        
        self.relationship = relationship
        self.from = from
        self.to = to
        self.adjustNullability = adjustNullability
    }
    
    public init(relationship: Relationship,
                signatureMapper: SignatureMapper,
                adjustNullability: Bool) {
        
        self.relationship = relationship
        self.from = signatureMapper.from
        self.to = signatureMapper.to
        self.adjustNullability = adjustNullability
        
    }
    
    public func canApply(to signature: FunctionSignature) -> Bool {
        return signature.matchesAsSelector(from)
    }
    
    public func apply(to signature: inout FunctionSignature) -> Bool {
        guard signature.matchesAsSelector(from) else {
            return false
        }
        
        signature.name = to.name
        
        for i in to.parameters.indices {
            signature.parameters[i].label = to.parameters[i].label
        }
        
        if adjustNullability {
            signature = mergeSignatures(to, signature)
        }
        
        return true
    }
    
    enum Relationship {
        case subtype(String)
        case conformance(protocolName: String)
        
        var typeName: String {
            switch self {
            case .subtype(let type), .conformance(let type):
                return type
            }
        }
    }
}
