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
        addConversion(fromKeywords: ["drawRect", nil], to: ["draw", nil])
    }
    
    func addConversion(fromKeywords k1: [String?], to k2: [String?]) {
        conversions.append(
            SignatureConversion(
                from: SelectorSignature(isStatic: false, keywords: k1),
                to: SelectorSignature(isStatic: false, keywords: k2)
            )
        )
    }
    
    override func applyOnMethod(_ method: MethodGenerationIntention) {
        guard let type = method.type as? ClassGenerationIntention else {
            return
        }
        if !context.typeSystem.isType(type.typeName, subtypeOf: "UIView") {
            return
        }
        
        for conversion in conversions {
            if conversion.apply(to: &method.signature) {
                // Mark as override
                method.isOverride = true
                
                return
            }
        }
    }
}

private class SignatureConversion {
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
    public init(from: SelectorSignature, to: SelectorSignature) {
        precondition(from.keywords.count == to.keywords.count)
        precondition(!from.keywords.isEmpty)
        
        self.from = from
        self.to = to
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
}
