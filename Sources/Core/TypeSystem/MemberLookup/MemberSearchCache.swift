import Utils
import KnownType
import SwiftAST

internal final class MemberSearchCache {
    @ConcurrentValue private var methodsCache: [MethodSearchEntry: KnownMethod?] = [:]
    @ConcurrentValue private var propertiesCache: [PropertySearchEntry: KnownProperty?] = [:]
    @ConcurrentValue private var fieldsCache: [FieldSearchEntry: KnownProperty?] = [:]
    @ConcurrentValue private var byNameMembersCache: [ByNameMemberSearchEntry: KnownMember?] = [:]
    @ConcurrentValue private var subscriptsCache: [SubscriptSearchEntry: KnownSubscript?] = [:]

    var usingCache: Bool = false

    func makeCache() {
        usingCache = true
        _methodsCache.setAsCaching(value: [:])
        _propertiesCache.setAsCaching(value: [:])
        _fieldsCache.setAsCaching(value: [:])
        _subscriptsCache.setAsCaching(value: [:])
    }

    func tearDownCache() {
        usingCache = false
        _methodsCache.tearDownCaching(resetToValue: [:])
        _propertiesCache.tearDownCaching(resetToValue: [:])
        _fieldsCache.tearDownCaching(resetToValue: [:])
        _subscriptsCache.tearDownCaching(resetToValue: [:])
    }

    func storeMethod(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool,
        in typeName: String,
        method: KnownMethod?
    ) {
        
        let entry = MethodSearchEntry(
            identifier: identifier,
            invocationTypeHints: invocationTypeHints,
            isStatic: isStatic,
            includeOptional: includeOptional,
            typeName: typeName
        )
        
        methodsCache[entry] = method
    }

    func storeProperty(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool,
        in typeName: String,
        property: KnownProperty?
    ) {

        let entry = PropertySearchEntry(
            name: name,
            isStatic: isStatic,
            includeOptional: includeOptional,
            typeName: typeName
        )
        
        propertiesCache[entry] = property
    }

    func storeMember(
        named name: String,
        static isStatic: Bool,
        in typeName: String,
        member: KnownMember?
    ) {
        
        let entry = ByNameMemberSearchEntry(
            name: name,
            isStatic: isStatic,
            typeName: typeName
        )

        byNameMembersCache[entry] = member
    }

    func storeField(
        named name: String,
        static isStatic: Bool,
        in typeName: String,
        field: KnownProperty?
    ) {
        
        let entry = FieldSearchEntry(
            name: name,
            isStatic: isStatic,
            typeName: typeName
        )
        
        fieldsCache[entry] = field
    }
    
    func storeSubscript(
        withParameterLabels labels: [String?],
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        in typeName: String,
        `subscript` sub: KnownSubscript?
    ) {
        
        let entry = SubscriptSearchEntry(
            labels: labels,
            invocationTypeHints: invocationTypeHints,
            isStatic: isStatic,
            typeName: typeName
        )
        
        subscriptsCache[entry] = sub
    }

    func lookupMethod(
        withIdentifier identifier: FunctionIdentifier,
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        includeOptional: Bool,
        in typeName: String
    ) -> KnownMethod?? {
        
        let entry = MethodSearchEntry(
            identifier: identifier,
            invocationTypeHints: invocationTypeHints,
            isStatic: isStatic,
            includeOptional: includeOptional,
            typeName: typeName
        )
        
        return methodsCache[entry]
    }

    func lookupProperty(
        named name: String,
        static isStatic: Bool,
        includeOptional: Bool,
        in typeName: String
    ) -> KnownProperty?? {
        
        let entry = PropertySearchEntry(
            name: name,
            isStatic: isStatic,
            includeOptional: includeOptional,
            typeName: typeName
        )
        
        return propertiesCache[entry]
    }

    func lookupField(
        named name: String,
        static isStatic: Bool,
        in typeName: String
    ) -> KnownProperty?? {
        
        let entry = FieldSearchEntry(
            name: name,
            isStatic: isStatic,
            typeName: typeName
        )
        
        return fieldsCache[entry]
    }

    func lookupMember(
        named name: String,
        static isStatic: Bool,
        in typeName: String
    ) -> KnownMember?? {
        
        let entry = ByNameMemberSearchEntry(
            name: name,
            isStatic: isStatic,
            typeName: typeName
        )

        return byNameMembersCache[entry]
    }
    
    func lookupSubscription(
        withParameterLabels labels: [String?],
        invocationTypeHints: [SwiftType?]?,
        static isStatic: Bool,
        in typeName: String
    ) -> KnownSubscript?? {
        
        let entry = SubscriptSearchEntry(
            labels: labels,
            invocationTypeHints: invocationTypeHints,
            isStatic: isStatic,
            typeName: typeName
        )
        
        return subscriptsCache[entry]
    }

    struct MethodSearchEntry: Hashable {
        var identifier: FunctionIdentifier
        var invocationTypeHints: [SwiftType?]?
        var isStatic: Bool
        var includeOptional: Bool
        var typeName: String
    }

    struct PropertySearchEntry: Hashable {
        var name: String
        var isStatic: Bool
        var includeOptional: Bool
        var typeName: String
    }

    struct FieldSearchEntry: Hashable {
        var name: String
        var isStatic: Bool
        var typeName: String
    }

    struct ByNameMemberSearchEntry: Hashable {
        var name: String
        var isStatic: Bool
        var typeName: String
    }
    
    struct SubscriptSearchEntry: Hashable {
        var labels: [String?]
        var invocationTypeHints: [SwiftType?]?
        var isStatic: Bool
        var typeName: String
    }
}
