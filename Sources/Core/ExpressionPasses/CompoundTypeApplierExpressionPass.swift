import Utils
import SwiftAST
import Commons

/// Applies passes with transformations from compounded types
public class CompoundTypeApplierExpressionPass: BaseExpressionPass {
    
    public required init(context: ASTRewriterPassContext) {
        super.init(context: context)
        
        addTypes()
    }
}

extension CompoundTypeApplierExpressionPass {
    func addTypes() {
        let types = CompoundedMappingTypeList.typeList()
        
        for type in types {
            addCompoundedType(type)
        }
    }
}
