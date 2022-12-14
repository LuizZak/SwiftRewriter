import SwiftAST
import KnownType

/// Provides member lookups for `SwiftType`s.
class SwiftTypeMemberLookup: MemberLookupType {
    private let type: SwiftType
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
    
    init(type: SwiftType,context: TypeMemberLookupContext) {
        self.type = type
        self.context = context
    }

    func makeKnownTypeLookup(_ type: KnownType) -> KnownTypeMemberLookup {
        context.makeKnownTypeLookup(type)
    }
    
    func makeSwiftTypeLookup(_ type: SwiftType) -> SwiftTypeMemberLookup {
        context.makeSwiftTypeLookup(type)
    }
    
    public func method(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool
    ) -> KnownMethod? {
        
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result =
                memberSearchCache.lookupMethod(
                    withIdentifier: identifier,
                    invocationTypeHints: invocationTypeHints,
                    static: isStatic,
                    includeOptional: includeOptional,
                    in: typeName
                )
            {
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }

        let lookup = makeKnownTypeLookup(knownType)
        let result = lookup.method(
            withIdentifier: identifier,
            invocationTypeHints: invocationTypeHints,
            static: isStatic,
            includeOptional: includeOptional
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
    
    public func property(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool
    ) -> KnownProperty? {
        
        let typeName =
            memberSearchCache.usingCache
                ? typeNameIn(swiftType: type)
                : nil
        
        if memberSearchCache.usingCache, let typeName = typeName {
            if let result =
                memberSearchCache.lookupProperty(
                    named: name,
                    static: isStatic,
                    includeOptional: includeOptional,
                    in: typeName
                )
            {
                return result
            }
        }
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        let lookup = makeKnownTypeLookup(knownType)

        let result = lookup.property(
            named: name,
            static: isStatic,
            includeOptional: includeOptional
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
    
    public func field(named name: String, static isStatic: Bool) -> KnownProperty? {
        
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
        
        let lookup = makeKnownTypeLookup(knownType)
        let result = lookup.field(named: name, static: isStatic)

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
    
    public func member(named name: String, static isStatic: Bool) -> KnownMember? {
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
        
        let lookup = makeKnownTypeLookup(knownType)

        let result = lookup.member(named: name, static: isStatic)
        
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
        static isStatic: Bool
    ) -> KnownSubscript? {
        
        guard let knownType = typeSystem.findType(for: type) else {
            return nil
        }
        
        let lookup = makeKnownTypeLookup(knownType)
        return lookup.subscription(
            withParameterLabels: labels,
            invocationTypeHints: invocationTypeHints,
            static: isStatic
        )
    }
}
