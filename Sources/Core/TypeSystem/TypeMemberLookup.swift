import SwiftAST
import KnownType

class TypeMemberLookup {
    private let typeSystem: TypeSystem
    private let memberSearchCache: MemberSearchCache
    private var visitedTypes: Set<String> = []
    
    init(typeSystem: TypeSystem, memberSearchCache: MemberSearchCache) {
        self.typeSystem = typeSystem
        self.memberSearchCache = memberSearchCache
    }
    
    func method(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool,
        in type: KnownType
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
        
        let result = _method(
            withIdentifier: identifier,
            invocationTypeHints: invocationTypeHints,
            static: isStatic,
            includeOptional: includeOptional,
            in: type
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
    
    private func _method(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool,
        in type: KnownType
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
                        .findBestOverload(in: methods,
                                          argumentTypes: invocationTypeHints)
                        ?? methods.first {
                    
                    return method
                }
            }
        }
        
        // Search on supertypes
        let onSupertype =
            typeSystem.supertype(of: type)
                .flatMap {
                    method(
                        withIdentifier: identifier,
                        invocationTypeHints: invocationTypeHints,
                        static: isStatic,
                        includeOptional: includeOptional,
                        in: $0
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
            
            if let method = method(withIdentifier: identifier,
                                   invocationTypeHints: invocationTypeHints,
                                   static: isStatic,
                                   includeOptional: includeOptional,
                                   in: prot) {
                
                return method
            }
        }
        
        return nil
    }
    
    func property(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool,
        in type: KnownType
    ) -> KnownProperty? {
        
        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupProperty(named: name,
                                             static: isStatic,
                                             includeOptional: includeOptional,
                                             in: type.typeName) {
            
            return result
        }
        
        let result = _property(
            named: name,
            static: isStatic,
            includeOptional: includeOptional,
            in: type
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
    
    private func _property(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool,
        in type: KnownType
    ) -> KnownProperty? {
        
        visitedTypes.insert(type.typeName)
        
        if let property = type.knownProperties.first(where: {
            $0.name == name
                && $0.isStatic == isStatic
                && (includeOptional || !$0.optional)
        }) {
            return property
        }
        
        // Search on supertypes
        return typeSystem.supertype(of: type).flatMap {
            property(
                named: name,
                static: isStatic,
                includeOptional: includeOptional,
                in: $0
            )
        }
    }
    
    func field(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty? {
        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupField(named: name,
                                          static: isStatic,
                                          in: type.typeName) {
            
            return result
        }
        
        let result = _field(named: name, static: isStatic, in: type)
        
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
    
    func _field(named name: String, static isStatic: Bool, in type: KnownType) -> KnownProperty? {
        if let field =
            type.knownFields
                .first(where: { $0.name == name && $0.isStatic == isStatic }) {
            return field
        }
        
        // Search on supertypes
        return typeSystem.supertype(of: type).flatMap {
            field(named: name, static: isStatic, in: $0)
        }
    }

    func member(
        named name: String,
        static isStatic: Bool,
        in type: KnownType
    ) -> KnownMember? {

        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupMember(named: name,
                                          static: isStatic,
                                          in: type.typeName) {
            
            return result
        }
        
        let result = _member(named: name, static: isStatic, in: type)
        
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
    
    func _member(
        named name: String,
        static isStatic: Bool,
        in type: KnownType
    ) -> KnownMember? {
        
        if let member = _property(named: name, static: isStatic, includeOptional: true, in: type) {
            return member
        }
        if let member = _field(named: name, static: isStatic, in: type) {
            return member
        }

        for method in type.knownMethods {
            if method.signature.name == name && method.isStatic == isStatic {
                return method
            }
        }
        
        // Search on supertypes
        return typeSystem.supertype(of: type).flatMap {
            member(named: name, static: isStatic, in: $0)
        }
    }

    public func subscription(
        withParameterLabels labels: [String?],
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        in type: KnownType
    ) -> KnownSubscript? {
        
        visitedTypes.insert(type.typeName)
        
        if memberSearchCache.usingCache,
            let result =
            memberSearchCache.lookupSubscription(withParameterLabels: labels,
                                                 invocationTypeHints: invocationTypeHints,
                                                 static: isStatic,
                                                 in: type.typeName) {
            
            return result
        }
        
        let result = _subscription(
            withParameterLabels: labels,
            invocationTypeHints: invocationTypeHints,
            static: isStatic,
            in: type
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
    
    private func _subscription(
        withParameterLabels labels: [String?],
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        in type: KnownType
    ) -> KnownSubscript? {
        
        let subscripts =
            type.knownSubscripts
                .filter {
                    $0.isStatic == isStatic
                        && $0.parameters.subscriptArgumentLabels() == labels
                }
        
        if !subscripts.isEmpty {
            if subscripts.count == 1 || invocationTypeHints == nil {
                return subscripts[0]
            }
            
            // Attempt overload resolution based on argument type information
            if let invocationTypeHints = invocationTypeHints,
                labels.count == invocationTypeHints.count {
                
                if let method =
                    typeSystem.overloadResolver()
                        .findBestOverload(inSubscripts: subscripts,
                                          arguments: invocationTypeHints.asOverloadResolverArguments)
                        ?? subscripts.first {
                    
                    return method
                }
            }
        }
        
        // Search on supertypes
        let onSupertype =
            typeSystem.supertype(of: type)
                .flatMap {
                    subscription(
                        withParameterLabels: labels,
                        invocationTypeHints: invocationTypeHints,
                        static: isStatic,
                        in: $0
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
            
            if let method = subscription(withParameterLabels: labels,
                                         invocationTypeHints: invocationTypeHints,
                                         static: isStatic,
                                         in: prot) {
                
                return method
            }
        }
        
        return nil
    }
    
    func method(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool,
        in type: SwiftType
    ) -> KnownMethod? {
        
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result =
                memberSearchCache.lookupMethod(withIdentifier: identifier,
                                               invocationTypeHints: invocationTypeHints,
                                               static: isStatic,
                                               includeOptional: includeOptional,
                                               in: typeName) {
                
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        let result = method(
            withIdentifier: identifier,
            invocationTypeHints: invocationTypeHints,
            static: isStatic,
            includeOptional: includeOptional,
            in: knownType
        )
        
        if memberSearchCache.usingCache, let typeName = typeName {
            memberSearchCache.storeMethod(
                withIdentifier: identifier,
                invocationTypeHints: invocationTypeHints,
                static: isStatic,
                includeOptional: includeOptional,
                in: typeName,
                method: result
            )
        }
        
        return result
    }
    
    /// Gets a property with a given name on a given known type, also specifying
    /// whether to include optional methods (from optional protocol methods that
    /// where not implemented by a concrete class).
    public func property(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool,
        in type: SwiftType
    ) -> KnownProperty? {
        
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result =
                memberSearchCache.lookupProperty(named: name,
                                                 static: isStatic,
                                                 includeOptional: includeOptional,
                                                 in: typeName) {
                
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        let result = property(
            named: name,
            static: isStatic,
            includeOptional: includeOptional,
            in: knownType
        )
        
        if memberSearchCache.usingCache, let typeName = typeName {
            memberSearchCache.storeProperty(
                named: name,
                static: isStatic,
                includeOptional: includeOptional,
                in: typeName,
                property: result
            )
        }
        
        return result
    }
    
    /// Gets an instance field with a given name on a given known type.
    public func field(named name: String, static isStatic: Bool, in type: SwiftType) -> KnownProperty? {
        
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result = memberSearchCache.lookupField(named: name, static: isStatic, in: typeName) {
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        
        let result = field(named: name, static: isStatic, in: knownType)
        
        if memberSearchCache.usingCache, let typeName = typeName {
            memberSearchCache.storeField(
                named: name,
                static: isStatic,
                in: typeName,
                field: result
            )
        }
        
        return result
    }
    
    /// Gets a member field with a given name on a given known type.
    public func member(named name: String, static isStatic: Bool, in type: SwiftType) -> KnownMember? {
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result = memberSearchCache.lookupMember(named: name, static: isStatic, in: typeName) {
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        
        let result = member(named: name, static: isStatic, in: knownType)
        
        if memberSearchCache.usingCache, let typeName = typeName {
            memberSearchCache.storeMember(
                named: name,
                static: isStatic,
                in: typeName,
                member: result
            )
        }
        
        return result
    }
    
    public func subscription(
        withParameterLabels labels: [String?],
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        in type: SwiftType
    ) -> KnownSubscript? {
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        
        return subscription(
            withParameterLabels: labels,
            invocationTypeHints: invocationTypeHints,
            static: isStatic,
            in: knownType
        )
    }
}
