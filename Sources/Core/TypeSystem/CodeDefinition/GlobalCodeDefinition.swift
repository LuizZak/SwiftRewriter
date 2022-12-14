import SwiftAST

public class GlobalCodeDefinition: CodeDefinition {
    public override func isEqual(to other: CodeDefinition) -> Bool {
        switch other {
        case let other as GlobalCodeDefinition:
            return isEqual(to: other)
        default:
            return super.isEqual(to: other)
        }
    }

    public func isEqual(to other: GlobalCodeDefinition) -> Bool {
        kind == other.kind
    }
}

public extension CodeDefinition {
    static func forGlobalFunction(signature: FunctionSignature) -> GlobalCodeDefinition {
        GlobalCodeDefinition(functionSignature: signature)
    }
    
    static func forGlobalVariable(name: String, isConstant: Bool, type: SwiftType) -> GlobalCodeDefinition {
        if isConstant {
            return GlobalCodeDefinition(constantNamed: name, type: type)
        }
        
        return GlobalCodeDefinition(variableNamed: name, type: type)
    }
}
