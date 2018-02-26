import SwiftAST

/// A basic protocol with two front-end methods for requesting resolving of types
/// of expression and statements
public protocol TypeResolverInvoker {
    /// Invocates the resolution of all expressions on a given statement recursively.
    func resolveTypes(in statement: Statement)
    
    /// Invocates the resolution of types for all expressions from all method bodies
    /// contained within an intention collection.
    func resolveAllTypes(in intentions: IntentionCollection)
    
    /// Invocates the resolution of a given expression's type.
    func resolveType(_ exp: Expression)
}

/// Handy class used to apply a series of `SyntaxNodeRewriterPass` instances to
/// all function bodies found in one go.
public class SyntaxNodeRewriterPassApplier: TypeResolverInvoker {
    public var passes: [SyntaxNodeRewriterPass]
    public var typeResolver: ExpressionTypeResolver
    
    public init(passes: [SyntaxNodeRewriterPass], typeResolver: ExpressionTypeResolver) {
        self.passes = passes
        self.typeResolver = typeResolver
    }
    
    public func resolveTypes(in statement: Statement) {
        typeResolver.resolveTypes(in: statement)
    }
    
    public func resolveAllTypes(in intentions: IntentionCollection) {
        apply(on: intentions, resolveTypesOnly: true)
    }
    
    public func resolveType(_ exp: Expression) {
        typeResolver.resolveType(exp)
    }
    
    public func apply(on intentions: IntentionCollection) {
        apply(on: intentions, resolveTypesOnly: false)
    }
    
    // MARK: - Private members
    
    private func apply(on intentions: IntentionCollection, resolveTypesOnly: Bool) {
        let files = intentions.fileIntentions()
        
        for file in files {
            applyOnFile(file, resolveTypesOnly: resolveTypesOnly)
        }
    }
    
    private func applyOnFile(_ file: FileGenerationIntention, resolveTypesOnly: Bool) {
        for cls in file.classIntentions {
            applyOnClass(cls, resolveTypesOnly: resolveTypesOnly)
        }
        
        for cls in file.extensionIntentions {
            applyOnClass(cls, resolveTypesOnly: resolveTypesOnly)
        }
    }
    
    private func applyOnFunction(_ f: FunctionIntention, resolveTypesOnly: Bool) {
        if let method = f.functionBody {
            applyOnFunctionBody(method, resolveTypesOnly: resolveTypesOnly)
        }
    }
    
    private func applyOnFunctionBody(_ functionBody: FunctionBodyIntention, resolveTypesOnly: Bool) {
        // Resolve types before feeding into passes
        typeResolver.resolveTypes(in: functionBody.body)
        
        if resolveTypesOnly {
            return
        }
        
        passes.forEach {
            _=functionBody.body.accept($0)
            
            // After each apply to the body, we must re-type check the result
            // before handing it off to the next pass.
            typeResolver.resolveTypes(in: functionBody.body)
        }
    }
    
    private func applyOnClass(_ cls: BaseClassIntention, resolveTypesOnly: Bool) {
        for prop in cls.properties {
            applyOnProperty(prop, resolveTypesOnly: resolveTypesOnly)
        }
        
        for method in cls.methods {
            applyOnMethod(method, resolveTypesOnly: resolveTypesOnly)
        }
    }
    
    private func applyOnMethod(_ method: MethodGenerationIntention, resolveTypesOnly: Bool) {
        setupIntrinsics(forMember: method)
        defer {
            tearDownIntrinsics()
        }
        
        applyOnFunction(method, resolveTypesOnly: resolveTypesOnly)
    }
    
    private func applyOnProperty(_ property: PropertyGenerationIntention, resolveTypesOnly: Bool) {
        setupIntrinsics(forMember: property)
        defer {
            tearDownIntrinsics()
        }
        
        switch property.mode {
        case .computed(let intent):
            applyOnFunctionBody(intent, resolveTypesOnly: resolveTypesOnly)
        case let .property(get, set):
            applyOnFunctionBody(get, resolveTypesOnly: resolveTypesOnly)
            applyOnFunctionBody(set.body, resolveTypesOnly: resolveTypesOnly)
        case .asField:
            break
        }
    }
    
    private func setupIntrinsics(forMember member: MemberGenerationIntention) {
        let intrinsics = DefaultCodeScope()
        
        // Push `self` intrinsic member variable
        if let type = member.type {
            let selfType = SwiftType.typeName(type.typeName)
            
            if member.isStatic {
                // Class `self` points to metatype of the class
                intrinsics.recordDefinition(
                    CodeDefinition(name: "self", type: .metatype(for: selfType))
                )
            } else {
                // Instance `self` points to the actual instance
                intrinsics.recordDefinition(
                    CodeDefinition(name: "self", type: selfType)
                )
            }
        }
        
        typeResolver.intrinsicVariables = intrinsics
    }
    
    /// Always call this before returning from a method that calls
    /// `setupIntrinsics(forMember:)`
    private func tearDownIntrinsics() {
        typeResolver.intrinsicVariables = EmptyCodeScope()
    }
}
