import SwiftAST
import SwiftRewriterLib

/// Globals provider for `UIKit` framework
public class UIKitGlobalsProvider: BaseGlobalsProvider {
    public override init() {
        
    }
    
    override func createTypes() {
        createUIView()
    }
    
    func createUIView() {
        let supertype = KnownSupertype.typeName("UIResponder")
        
        makeType(named: "UIView", supertype: supertype, kind: .class) { (type) -> (KnownType) in
            type
                // Fields
                .field(named: "tag", type: .int)
                .field(named: "isUserInteractionEnabled", type: .bool)
                // Properties
                .property(named: "frame", type: .typeName("CGRect"))
                .property(named: "bounds", type: .typeName("CGRect"))
                .property(named: "layer", type: .typeName("CALayer"), accessor: .getter)
                // Constructors
                .constructor(shortParameters: [("frame", .typeName("CGRect"))])
                // Methods
                .method(withSignature:
                    FunctionSignature(name: "draw", parameters: [
                        ParameterSignature(label: "_", name: "rect", type: .typeName("CGRect"))
                    ])
                )
                .build()
            }
    }
}
