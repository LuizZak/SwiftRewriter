import SwiftAST

/// Represents a local context for constructing types with.
public class TypeConstructionContext {
    var typeSystem: TypeSystem
    var instanceTypeValue: SwiftType?
    
    public init(typeSystem: TypeSystem) {
        self.typeSystem = typeSystem
    }
}
