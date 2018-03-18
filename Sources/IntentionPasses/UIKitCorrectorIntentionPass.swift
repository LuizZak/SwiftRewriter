import SwiftAST
import SwiftRewriterLib

/// Makes correction for signatures of subclasses and conformeds of known UIKit
/// classes and protocols
public class UIKitCorrectorIntentionPass: ClassVisitingIntentionPass {
    private var conversions: [SignatureConversion] = []
    
    public override init() {
        super.init()
        
        createConversions()
    }
    
    func createConversions() {
        addConversion(.subtype("UIView"), fromKeywords: ["drawRect", nil], to: ["draw", nil])
        
        // UITableViewDelegate
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
        conversions.append(
            SignatureConversion(
                relationship: relationship,
                from: SelectorSignature(isStatic: false, keywords: k1),
                to: SelectorSignature(isStatic: false, keywords: k2)
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
            // Check relationship matches
            switch conversion.relationship {
            case .subtype(let typeName):
                if !context.typeSystem.isType(type.typeName, subtypeOf: typeName) {
                    continue
                }
            case .conformance(let protocolName):
                if !context.typeSystem.isType(type.typeName, conformingTo: protocolName) {
                    continue
                }
            }
            
            if !conversion.apply(to: &method.signature) {
                continue
            }
            
            // Mark as override, in case of subtype relationship
            if case .subtype = conversion.relationship {
                method.isOverride = true
            }
            
            notifyChange()
            
            return
        }
    }
}

private class SignatureConversion {
    let relationship: Relationship
    let from: SelectorSignature
    let to: SelectorSignature
    
    /// Creates a new `SignatureConversion` instance with a given source and target
    /// signatures to convert.
    ///
    /// Count of keywords on both signatures must match (i.e. cannot change the
    /// number of arguments of a method)
    ///
    /// - precondition: `from.count == to.count`
    /// - precondition: `from.count > 0`
    public init(relationship: Relationship, from: SelectorSignature, to: SelectorSignature) {
        precondition(from.keywords.count == to.keywords.count, "from.keywords.count == to.keywords.count")
        precondition(!from.keywords.isEmpty, "!from.keywords.isEmpty")
        
        self.relationship = relationship
        self.from = from
        self.to = to
    }
    
    public func canApply(to signature: FunctionSignature) -> Bool {
        return signature.asSelector == from
    }
    
    public func apply(to signature: inout FunctionSignature) -> Bool {
        guard signature.asSelector == from else {
            return false
        }
        
        signature.name = to.keywords[0] ?? "__"
        
        for i in 0..<to.keywords.count - 1 {
            signature.parameters[i].label = to.keywords[i + 1] ?? "_"
        }
        
        return true
    }
    
    enum Relationship {
        case subtype(String)
        case conformance(protocolName: String)
    }
}
