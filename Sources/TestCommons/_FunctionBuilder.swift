import SwiftAST
import Intentions

public protocol _FunctionBuilder {
    associatedtype FunctionType = FunctionIntention
    var target: FunctionType { get nonmutating set }
}

public extension _FunctionBuilder where FunctionType: MutableSignatureFunctionIntention {
    var signature: FunctionSignature { get { return target.signature } nonmutating set { target.signature = newValue } }
    
    // TODO: It is less than ideal to repeat the name argument here, since most
    // likely the user got here from function builders that already require a
    // name during their creation.
    @discardableResult
    func createSignature(name: String, _ builder: (FunctionSignatureBuilder) -> Void) -> Self {
        let b = FunctionSignatureBuilder(signature: FunctionSignature(name: name))
        
        builder(b)
        
        target.signature = b.build()
        
        return self
    }
}

extension _FunctionBuilder where FunctionType: MutableFunctionIntention {
    @discardableResult
    public func setBody(_ body: CompoundStatement) -> Self {
        target.functionBody = FunctionBodyIntention(body: body)
        
        return self
    }
}
