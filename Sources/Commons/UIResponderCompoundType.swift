import SwiftAST
import SwiftRewriterLib

public enum UIResponderCompoundType {
    private static var singleton: CompoundedMappingType = {
        let mappings = createMappings()
        let type = createType()
    
        return CompoundedMappingType(knownType: type, signatureMappings: mappings)
    }()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createMappings() -> [SignatureMapper] {
        let mappings = SignatureMapperBuilder()
        
        return mappings.build()
    }
    
    static func createType() -> KnownType {
        var type = KnownTypeBuilder(typeName: "UIResponder", supertype: "NSObject")
        
        type.useSwiftSignatureMatching = true
        
        type = type
            // Protocol conformances
            .protocolConformance(protocolName: "UIResponderStandardEditActions")
        
        type = type
            // Properties
            .property(named: "canBecomeFirstResponder", type: .bool, accessor: .getter)
            .property(named: "canResignFirstResponder", type: .bool, accessor: .getter)
            .property(named: "isFirstResponder", type: .optional("UIResponder"), accessor: .getter)
            .property(named: "undoManager", type: .optional("UndoManager"), accessor: .getter)
        
        // Methods
        type = type
            .method(named: "canPerformAction",
                    parsingSignature: "(_ action: Selector, withSender sender: Any?)",
                    returning: .bool)
            .method(named: "resignFirstResponder",
                    returning: .bool)
            .method(named: "target",
                    parsingSignature: "(forAction action: Selector, withSender sender: Any?)",
                    returning: .optional(.any))
            .method(named: "motionBegan",
                    parsingSignature: "(_ motion: UIEventSubtype, with event: UIEvent?)")
            .method(named: "motionCancelled",
                    parsingSignature: "(_ motion: UIEventSubtype, with event: UIEvent?)")
            .method(named: "motionEnded",
                    parsingSignature: "(_ motion: UIEventSubtype, with event: UIEvent?)")
            .method(named: "pressesBegan",
                    parsingSignature: "(_ presses: Set<UIPress>, with event: UIPressesEvent?)")
            .method(named: "pressesCancelled",
                    parsingSignature: "(_ presses: Set<UIPress>, with event: UIPressesEvent?)")
            .method(named: "pressesChanged",
                    parsingSignature: "(_ presses: Set<UIPress>, with event: UIPressesEvent?)")
            .method(named: "pressesEnded",
                    parsingSignature: "(_ presses: Set<UIPress>, with event: UIPressesEvent?)")
            .method(named: "remoteControlReceived",
                    parsingSignature: "(with event: UIEvent?)")
            .method(named: "touchesBegan",
                    parsingSignature: "(_ touches: Set<UITouch>, with event: UIEvent?)")
            .method(named: "touchesCancelled",
                    parsingSignature: "(_ touches: Set<UITouch>, with event: UIEvent?)")
            .method(named: "touchesEnded",
                    parsingSignature: "(_ touches: Set<UITouch>, with event: UIEvent?)")
            .method(named: "touchesEstimatedPropertiesUpdated",
                    parsingSignature: "(_ touches: Set<UITouch>)")
            .method(named: "touchesMoved",
                    parsingSignature: "(_ touches: Set<UITouch>, with event: UIEvent?)")
        
        return type.build()
    }
}
