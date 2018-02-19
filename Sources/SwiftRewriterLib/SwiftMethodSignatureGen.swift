import GrammarModels

/// A helper class that can be used to generate a proper swift method signature
/// from an Objective-C method signature.
public class SwiftMethodSignatureGen {
    private let context: TypeContext
    private let typeMapper: TypeMapper
    
    public init(context: TypeContext, typeMapper: TypeMapper) {
        self.context = context
        self.typeMapper = typeMapper
    }
    
    /// Generates a function definition from an objective-c signature to use as
    /// a class-type function definition.
    public func generateDefinitionSignature(from objcMethod: MethodDefinition) -> FunctionSignature {
        var sign =
            FunctionSignature(isStatic: objcMethod.isClassMethod,
                              name: "__",
                              returnType: SwiftType.anyObject.asImplicitUnwrapped,
                              parameters: [])
        
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
            let swiftType =
                typeMapper.swiftType(forObjcType: type,
                                     context: .init(explicitNullability: nullability))
            
            sign.returnType = swiftType
        }
        
        return sign
    }
    
    private func processKeywords(_ keywords: [KeywordDeclarator],
                                 _ target: inout FunctionSignature) {
        guard keywords.count > 0 else {
            return
        }
        
        // First selector is always the method's name
        target.name = keywords[0].selector?.name ?? "__"
        
        for (i, kw) in keywords.enumerated() {
            var label = kw.selector?.name ?? "_"
            let identifier = kw.identifier?.name ?? "_\(i)"
            var nullability: TypeNullability = .unspecified
            let type = kw.type?.type?.type ?? ObjcType.id(protocols: [])
            
            // The first label name is always empty.
            // This matches the original Objective-C behavior of using the first
            // keyword as the method's name and the remaining keywords as labels
            // more closely.
            if i == 0 {
                label = "_"
            }
            
            if let nullSpecs = kw.type?.nullabilitySpecifiers {
                nullability = nullabilityFrom(specifiers: nullSpecs) ?? .unspecified
            }
            
            let swiftType =
                typeMapper.swiftType(forObjcType: type,
                                     context: .init(explicitNullability: nullability))
            
            let param = ParameterSignature(label: label, name: identifier, type: swiftType)
            
            target.parameters.append(param)
        }
        
        // Do a little Clang-like-magic here: If the method selector is in the
        // form `loremWithThing:thing...`, where after a `[...]With` prefix, a
        // noun is followed by a parameter that has the same name, we collapse
        // such selector in Swift as `lorem(with:)`.
        if let firstSelName = keywords[0].selector?.name, firstSelName.contains("With") {
            let split = firstSelName.components(separatedBy: "With")
            if split.count != 2 || split.contains(where: { $0.count < 2 }) {
                return
            }
            if split[1].lowercased() != keywords[0].identifier?.name.lowercased() {
                return
            }
            
            // All good! Collapse the identifier into a more 'swifty' construct
            target.name = split[0]
            target.parameters[0].label = "with"
        }
    }
    
    private func nullabilityFrom(specifiers: [NullabilitySpecifier]) -> TypeNullability? {
        let inNonnullContext = context.isAssumeNonnullOn
        
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
