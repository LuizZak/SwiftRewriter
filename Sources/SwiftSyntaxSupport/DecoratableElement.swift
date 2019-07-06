import SwiftAST
import Intentions

enum DecoratableElement {
    case intention(IntentionProtocol)
    case variableDecl(StatementVariableDeclaration)
    
    var intention: IntentionProtocol? {
        switch self {
        case .intention(let intention):
            return intention
        case .variableDecl:
            return nil
        }
    }
}
