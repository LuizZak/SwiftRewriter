/// A syntax node for an Objective-C class implementation (`@implementation`)
/// declaration.
public class ObjcClassImplementation: ASTNode, InitializableNode {
    public var identifier: ASTNodeRef<Identifier> = .invalid(InvalidNode())
    
    public required init() {
        
    }
}
