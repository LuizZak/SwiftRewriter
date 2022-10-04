import SwiftAST
import Intentions
import GrammarModelBase

public protocol _FunctionBuilder {
    associatedtype FunctionType = FunctionIntention
    var target: FunctionType { get nonmutating set }
}

public extension _FunctionBuilder where FunctionType: MutableSignatureFunctionIntention {
    var signature: FunctionSignature { get { target.signature } nonmutating set { target.signature = newValue } }
    
    @discardableResult
    func setSource(_ source: ASTNode) -> Self where FunctionType: FromSourceIntention {
        target.source = source

        return self
    }
    
    @discardableResult
    func createSignature(_ builder: (FunctionSignatureBuilder) -> Void) -> Self {
        let b = FunctionSignatureBuilder(signature: FunctionSignature(name: target.signature.name))
        
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
