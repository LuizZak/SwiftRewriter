import GrammarModels
import SwiftAST
import TypeSystem

/// A helper class that can be used to generate a proper swift method signature
/// from an Objective-C method signature.
public class SwiftMethodSignatureGen {
    private let typeMapper: TypeMapper
    private let inNonnullContext: Bool
    private let instanceTypeAlias: SwiftType?
    
    public init(typeMapper: TypeMapper, inNonnullContext: Bool, instanceTypeAlias: SwiftType? = nil) {
        self.typeMapper = typeMapper
        self.inNonnullContext = inNonnullContext
        self.instanceTypeAlias = instanceTypeAlias
    }
    
    /// Generates a function definition from an objective-c signature to use as
    /// a class-type function definition.
    public func generateDefinitionSignature(from objcMethod: MethodDefinition) -> FunctionSignature {
        var sign =
            FunctionSignature(name: "__",
                              parameters: [],
                              returnType: SwiftType.anyObject.asNullabilityUnspecified,
                              isStatic: objcMethod.isClassMethod,
                              isMutating: false)
        
        if let sel = objcMethod.methodSelector?.selector {
            switch sel {
            case .selector(let s):
                sign.name = s.name
            case .keywords(let kw):
                processKeywords(kw, &sign)
            }
        }
        
        var nullability = TypeNullability.unspecified
        
        // Nullability specifiers (from e.g. `... arg:(nullable NSString*)paramName ...`
        if let nullSpecs = objcMethod.returnType?.nullabilitySpecifiers {
            nullability = nullabilityFrom(specifiers: nullSpecs) ?? .unspecified
        }
        
        if let type = objcMethod.returnType?.type?.type {
            var context = TypeMappingContext(explicitNullability: nullability)
            context.instanceTypeAlias = instanceTypeAlias
            
            let swiftType =
                typeMapper.swiftType(forObjcType: type, context: context)
            
            sign.returnType = swiftType
        }
        
        return sign
    }
    
    /// Generates a function definition from a C signature to use as a global
    /// function signature.
    public func generateDefinitionSignature(from function: FunctionDefinition) -> FunctionSignature {
        var sign =
            FunctionSignature(name: function.identifier?.name ?? "__",
                              parameters: [],
                              returnType: .void,
                              isStatic: false,
                              isMutating: false)
        
        var context = TypeMappingContext.empty
        context.instanceTypeAlias = instanceTypeAlias
        
        if let returnType = function.returnType?.type {
            let swiftType = typeMapper.swiftType(forObjcType: returnType, context: context)
            sign.returnType = swiftType
        }
        
        if let parameterList = function.parameterList {
            for param in parameterList.parameters {
                guard let name = param.identifier?.name else {
                    continue
                }
                guard let type = param.type?.type else {
                    continue
                }
                
                let swiftType = typeMapper.swiftType(forObjcType: type, context: context)
                
                let p = ParameterSignature(label: nil, name: name, type: swiftType)
                sign.parameters.append(p)
            }
        }
        
        return sign
    }
    
    // MARK: - Private Members
    
    private func processKeywords(_ keywords: [KeywordDeclarator],
                                 _ target: inout FunctionSignature) {
        
        guard !keywords.isEmpty else {
            return
        }
        
        // First selector is always the method's name
        target.name = keywords[0].selector?.name ?? "__"
        
        for (i, kw) in keywords.enumerated() {
            var label = kw.selector?.name
            let identifier = kw.identifier?.name ?? "_\(i)"
            var nullability: TypeNullability? = nil
            let type = kw.type?.type?.type ?? ObjcType.id()
            
            // The first label name is always empty.
            // This matches the original Objective-C behavior of using the first
            // keyword as the method's name and the remaining keywords as labels
            // more closely.
            if i == 0 {
                label = nil
            }
            
            if let nullSpecs = kw.type?.nullabilitySpecifiers {
                nullability = nullabilityFrom(specifiers: nullSpecs)
            }
            
            var context = TypeMappingContext(explicitNullability: nullability)
            context.inNonnullContext = inNonnullContext
            context.instanceTypeAlias = instanceTypeAlias
            
            let swiftType = typeMapper.swiftType(forObjcType: type, context: context)
            
            let param = ParameterSignature(label: label, name: identifier, type: swiftType)
            
            target.parameters.append(param)
        }
    }
    
    private func nullabilityFrom(specifiers: [NullabilitySpecifier]) -> TypeNullability? {
        guard let last = specifiers.last else {
            return inNonnullContext ? .nonnull : nil
        }
        
        switch last.name {
        case "nonnull":
            return .nonnull
        case "nullable":
            return .nullable
        case "null_unspecified":
            return .unspecified
        default:
            return inNonnullContext ? .nonnull : nil
        }
    }
}
