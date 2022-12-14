import SwiftAST
import KnownType

/// Scopes lookups to a specific `KnownType` instance.
class KnownTypeMemberLookup: MemberLookupType {
    private let type: KnownType
    private let context: TypeMemberLookupContext

    private var typeSystem: TypeSystem {
        context.typeSystem
    }
    private var memberSearchCache: MemberSearchCache {
        context.memberSearchCache
    }
    private var visitedTypes: Set<String> {
        get {
            context.visitedTypes
        }
        set {
            context.visitedTypes = newValue
        }
    }
    
    init(type: KnownType, context: TypeMemberLookupContext) {
        self.type = type
        self.context = context
    }

    func makeKnownTypeLookup(_ type: KnownType) -> KnownTypeMemberLookup {
        context.makeKnownTypeLookup(type)
    }

    func makeSwiftTypeLookup(_ type: SwiftType) -> SwiftTypeMemberLookup {
        context.makeSwiftTypeLookup(type)
    }

    func makeDynamicTypeLookup() -> DynamicMemberLookup {
        DynamicMemberLookup(type: type, context: context)
    }

    func method(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool
    ) -> KnownMethod? {
        
        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupMethod(
                withIdentifier: identifier,
                invocationTypeHints: invocationTypeHints,
                static: isStatic,
                includeOptional: includeOptional,
                in: type.typeName
            ) {
            
            return result
        }
        
        let result = _methodUncached(
            withIdentifier: identifier,
            invocationTypeHints: invocationTypeHints,
            static: isStatic,
            includeOptional: includeOptional
        )
        
        if memberSearchCache.usingCache {
            memberSearchCache.storeMethod(
                withIdentifier: identifier,
                invocationTypeHints: invocationTypeHints,
                static: isStatic,
                includeOptional: includeOptional,
                in: type.typeName,
                method: result
            )
        }
        
        return result
    }
    
    func property(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool
    ) -> KnownProperty? {
        
        visitedTypes.insert(type.typeName)
        
        if
            memberSearchCache.usingCache,
            let result = memberSearchCache.lookupProperty(
                named: name,
                static: isStatic,
                includeOptional: includeOptional,
                in: type.typeName
            )
        {
            return result
        }
        
        let result = _propertyUncached(
            named: name,
            static: isStatic,
            includeOptional: includeOptional
        )
        
        if memberSearchCache.usingCache {
            memberSearchCache.storeProperty(
                named: name,
                static: isStatic,
                includeOptional: includeOptional,
                in: type.typeName,
                property: result
            )
        }
        
        return result
    }
    
    func field(named name: String, static isStatic: Bool) -> KnownProperty? {
        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupField(
                named: name,
                static: isStatic,
                in: type.typeName
            )
        {
            return result
        }
        
        let result = _fieldUncached(named: name, static: isStatic)
        
        if memberSearchCache.usingCache {
            memberSearchCache.storeField(
                named: name,
                static: isStatic,
                in: type.typeName,
                field: result
            )
        }
        
        return result
    }
    
    func member(
        named name: String,
        static isStatic: Bool
    ) -> KnownMember? {

        visitedTypes.insert(type.typeName)
        
        if
            memberSearchCache.usingCache,
            let result = memberSearchCache.lookupMember(
                named: name,
                static: isStatic,
                in: type.typeName
            )
        {
            return result
        }
        
        let result = _memberUncached(named: name, static: isStatic)
        
        if memberSearchCache.usingCache {
            memberSearchCache.storeMember(
                named: name,
                static: isStatic,
                in: type.typeName,
                member: result
            )
        }
        
        return result
    }
    
    func subscription(
        withParameterLabels labels: [String?],
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool
    ) -> KnownSubscript? {
        
        visitedTypes.insert(type.typeName)
        
        if
            memberSearchCache.usingCache,
            let result = memberSearchCache.lookupSubscription(
                withParameterLabels: labels,
                invocationTypeHints: invocationTypeHints,
                static: isStatic,
                in: type.typeName
            )
        {
            return result
        }
        
        let result = _subscriptionUncached(
            withParameterLabels: labels,
            invocationTypeHints: invocationTypeHints,
            static: isStatic
        )
        
        if memberSearchCache.usingCache {
            memberSearchCache.storeSubscript(
                withParameterLabels: labels,
                invocationTypeHints: invocationTypeHints,
                static: isStatic,
                in: type.typeName,
                subscript: result
            )
        }
        
        return result
    }
    
    // MARK: - Uncached lookup

    private func _methodUncached(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool
    ) -> KnownMethod? {
        
        let methods =
            type.knownMethods
                .filter {
                    $0.isStatic == isStatic
                        && (includeOptional || !$0.optional)
                        && $0.signature.possibleIdentifierSignatures().contains(identifier)
                }
        
        if !methods.isEmpty {
            if methods.count == 1 || invocationTypeHints == nil {
                return methods[0]
            }
            
            // Attempt overload resolution based on argument type information
            if let invocationTypeHints = invocationTypeHints,
                identifier.argumentLabels.count == invocationTypeHints.count {
                
                if let method =
                    typeSystem.overloadResolver()
                        .findBestOverload(
                            in: methods,
                            argumentTypes: invocationTypeHints
                        ) ?? methods.first
                {
                    
                    return method
                }
            }
        }
        
        // Search on supertypes
        let onSupertype = typeSystem.supertype(of: type).flatMap { superType in
            makeKnownTypeLookup(superType).method(
                withIdentifier: identifier,
                invocationTypeHints: invocationTypeHints,
                static: isStatic,
                includeOptional: includeOptional
            )
        }
        
        if let result = onSupertype {
            return result
        }
        
        // Search on protocol conformances
        for conformance in type.knownProtocolConformances {
            if visitedTypes.contains(conformance.protocolName) {
                continue
            }
            
            guard let prot = typeSystem.knownTypeWithName(conformance.protocolName) else {
                continue
            }
            let lookup = makeKnownTypeLookup(prot)
            
            if
                let method = lookup.method(
                    withIdentifier: identifier,
                    invocationTypeHints: invocationTypeHints,
                    static: isStatic,
                    includeOptional: includeOptional
                )
            {
                return method
            }
        }
        
        return nil
    }
    
    private func _propertyUncached(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool
    ) -> KnownProperty? {
        
        visitedTypes.insert(type.typeName)
        
        if
            let property = type.knownProperties.first(where: {
                $0.name == name
                    && $0.isStatic == isStatic
                    && (includeOptional || !$0.optional)
            })
        {
            return property
        }
        
        // Search on supertypes
        return typeSystem.supertype(of: type).flatMap { superType in
            makeKnownTypeLookup(superType).property(
                named: name,
                static: isStatic,
                includeOptional: includeOptional
            )
        }
    }
    
    private func _fieldUncached(named name: String, static isStatic: Bool) -> KnownProperty? {
        if
            let field = type.knownFields.first(where: {
                $0.name == name && $0.isStatic == isStatic
            })
        {
            return field
        }
        
        // Search on super types
        return typeSystem.supertype(of: type).flatMap { superType in
            makeKnownTypeLookup(superType)
                .field(named: name, static: isStatic)
        }
    }

    private func _memberUncached(
        named name: String,
        static isStatic: Bool
    ) -> KnownMember? {
        
        if let member = _propertyUncached(named: name, static: isStatic, includeOptional: true) {
            return member
        }
        if let member = _fieldUncached(named: name, static: isStatic) {
            return member
        }

        for method in type.knownMethods {
            if method.signature.name == name && method.isStatic == isStatic {
                return method
            }
        }
        
        // Search on super types
        let onSuperType = typeSystem.supertype(of: type).flatMap({ superType in
            makeKnownTypeLookup(superType)
                .member(named: name, static: isStatic)
        })
        
        if let onSuperType {
            return onSuperType
        }

        // Check for `@dynamicMemberLookup`
        if type.isDynamicMemberLookupType {
            let dynamicLookup = makeDynamicTypeLookup()

            let result = dynamicLookup.member(named: name, static: isStatic)

            switch result {
            case .declared(let member):
                return member
            case .dynamicMember(let member):
                return member
            case nil:
                break
            }
        }

        return nil
    }

    private func _subscriptionUncached(
        withParameterLabels labels: [String?],
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool
    ) -> KnownSubscript? {
        
        let subscripts = type.knownSubscripts.filter {
            $0.isStatic == isStatic
                && $0.parameters.subscriptArgumentLabels() == labels
        }
        
        if !subscripts.isEmpty {
            if subscripts.count == 1 || invocationTypeHints == nil {
                return subscripts[0]
            }
            
            // Attempt overload resolution based on argument type information
            if
                let invocationTypeHints = invocationTypeHints,
                labels.count == invocationTypeHints.count
            {
                if
                    let method = typeSystem.overloadResolver().findBestOverload(
                        inSubscripts: subscripts,
                        arguments: invocationTypeHints.asOverloadResolverArguments
                    ) ?? subscripts.first
                {
                    return method
                }
            }
        }
        
        // Search on supertypes
        let onSupertype = typeSystem.supertype(of: type).flatMap { superType in
            makeKnownTypeLookup(superType).subscription(
                withParameterLabels: labels,
                invocationTypeHints: invocationTypeHints,
                static: isStatic
            )
        }
        
        if let result = onSupertype {
            return result
        }
        
        // Search on protocol conformances
        for conformance in type.knownProtocolConformances {
            if visitedTypes.contains(conformance.protocolName) {
                continue
            }
            
            guard let prot = typeSystem.knownTypeWithName(conformance.protocolName) else {
                continue
            }
            let lookup = makeKnownTypeLookup(prot)
            
            if
                let method = lookup.subscription(
                    withParameterLabels: labels,
                    invocationTypeHints: invocationTypeHints,
                    static: isStatic
                )
            {
                return method
            }
        }
        
        return nil
    }
}

private extension KnownType {
    /// Returns `true` if this type has a `@dynamicMemberLookup` attribute.
    var isDynamicMemberLookupType: Bool {
        hasAttribute(named: KnownAttribute.dynamicMemberLookup.name)
    }
}
