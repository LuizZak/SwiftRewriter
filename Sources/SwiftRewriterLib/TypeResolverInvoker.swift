import SwiftAST

/// A basic protocol with two front-end methods for requesting resolving of types
/// of expression and statements on intention collections.
public protocol TypeResolverInvoker {
    /// Invocates the resolution of types for all expressions from all method bodies
    /// contained within an intention collection.
    func resolveAllExpressionTypes(in intentions: IntentionCollection)
    
    /// Resolves all types within a given method intention.
    func resolveExpressionTypes(in method: MethodGenerationIntention)
    
    /// Resolves all types from all expressions that may be contained within
    /// computed accessors of a given property
    func resolveExpressionTypes(in property: PropertyGenerationIntention)
}

public class DefaultTypeResolverInvoker: TypeResolverInvoker {
    public var typeResolver: ExpressionTypeResolver
    
    public init(typeResolver: ExpressionTypeResolver) {
        self.typeResolver = typeResolver
    }
    
    public func resolveAllExpressionTypes(in intentions: IntentionCollection) {
        apply(on: intentions)
    }
    
    public func resolveExpressionTypes(in method: MethodGenerationIntention) {
        applyOnMethod(method)
    }
    
    public func resolveExpressionTypes(in property: PropertyGenerationIntention) {
        applyOnProperty(property)
    }
    
    // MARK: - Private method
    internal func apply(on intentions: IntentionCollection) {
        let files = intentions.fileIntentions()
        
        for file in files {
            applyOnFile(file)
        }
    }
    
    internal func applyOnFile(_ file: FileGenerationIntention) {
        for cls in file.classIntentions {
            applyOnClass(cls)
        }
        
        for cls in file.extensionIntentions {
            applyOnClass(cls)
        }
    }
    
    internal func applyOnClass(_ cls: BaseClassIntention) {
        for prop in cls.properties {
            applyOnProperty(prop)
        }
        
        for method in cls.methods {
            applyOnMethod(method)
        }
    }
    
    internal func applyOnFunction(_ f: FunctionIntention) {
        if let method = f.functionBody {
            applyOnFunctionBody(method)
        }
    }
    
    internal func applyOnFunctionBody(_ functionBody: FunctionBodyIntention) {
        // Resolve types before feeding into passes
        typeResolver.resolveTypes(in: functionBody.body)
    }
    
    internal func applyOnMethod(_ method: MethodGenerationIntention) {
        setupIntrinsics(forMember: method)
        defer {
            tearDownIntrinsics()
        }
        
        applyOnFunction(method)
    }
    
    internal func applyOnProperty(_ property: PropertyGenerationIntention) {
        setupIntrinsics(forMember: property)
        defer {
            tearDownIntrinsics()
        }
        
        switch property.mode {
        case .computed(let intent):
            applyOnFunctionBody(intent)
        case let .property(get, set):
            applyOnFunctionBody(get)
            applyOnFunctionBody(set.body)
        case .asField:
            break
        }
    }
    
    internal func setupIntrinsics(forMember member: MemberGenerationIntention) {
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
        
        // Push file-level global variables
        
        
        typeResolver.intrinsicVariables = intrinsics
    }
    
    /// Always call this before returning from a method that calls
    /// `setupIntrinsics(forMember:)`
    internal func tearDownIntrinsics() {
        typeResolver.intrinsicVariables = EmptyCodeScope()
    }
}
