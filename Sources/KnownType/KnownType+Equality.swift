/// Returns `true` if two types have the same type signature.
func areEquivalent(_ type1: KnownType, _ type2: KnownType) -> Bool {
    if type1.typeName != type2.typeName
        || type1.kind != type2.kind
        || type1.supertype?.asTypeName != type2.supertype?.asTypeName
        || type1.knownTraits != type2.knownTraits {
        
        return false
    }
    
    if !compare(type1.knownMethods, type2.knownMethods, areEquivalent) {
        return false
    }
    if !compare(type1.knownConstructors, type2.knownConstructors, areEquivalent) {
        return false
    }
    if !compare(type1.knownProperties, type2.knownProperties, areEquivalent) {
        return false
    }
    if !compare(type1.knownFields, type2.knownFields, areEquivalent) {
        return false
    }
    if !compare(type1.knownSubscripts, type2.knownSubscripts, areEquivalent) {
        return false
    }
    if !compare(type1.knownProtocolConformances, type2.knownProtocolConformances, areEquivalent) {
        return false
    }
    
    return true
}

/// Returns `true` if two constructors match in signatures, attributes, and
/// semantics
func areEquivalent(_ ctor1: KnownConstructor, _ ctor2: KnownConstructor) -> Bool {
    return ctor1.annotations == ctor2.annotations
        && ctor1.knownAttributes == ctor2.knownAttributes
        && ctor1.parameters == ctor2.parameters
        && ctor1.isConvenience == ctor2.isConvenience
        && ctor1.isFailable == ctor2.isFailable
        && ctor1.semantics == ctor2.semantics
}

/// Returns `true` if two methods have the same signatures, attributes, and
/// sesmantics.
/// Bodies are ignored during comparison
func areEquivalent(_ method1: KnownMethod, _ method2: KnownMethod) -> Bool {
    return method1.signature == method2.signature
        && method1.optional == method2.optional
        && method1.annotations == method2.annotations
        && method1.annotations == method2.annotations
        && method1.knownAttributes == method2.knownAttributes
        && method1.semantics == method2.semantics
}

/// Returns `true` if two properties have the same signatures, attributes, and
/// sesmantics.
func areEquivalent(_ prop1: KnownProperty, _ prop2: KnownProperty) -> Bool {
    return prop1.name == prop2.name
        && prop1.storage == prop2.storage
        && prop1.isEnumCase == prop2.isEnumCase
        && prop1.objcAttributes == prop2.objcAttributes
        && prop1.optional == prop2.optional
        && prop1.annotations == prop2.annotations
        && prop1.isStatic == prop2.isStatic
        && prop1.knownAttributes == prop2.knownAttributes
        && prop1.semantics == prop2.semantics
}

/// Returns `true` if two subscripts have the same signatures, attributes, and
/// sesmantics.
func areEquivalent(_ sub1: KnownSubscript, _ sub2: KnownSubscript) -> Bool {
    return sub1.parameters == sub2.parameters
        && sub1.returnType == sub2.returnType
        && sub1.annotations == sub2.annotations
        && sub1.knownAttributes == sub2.knownAttributes
        && sub1.semantics == sub2.semantics
}

/// Returns `true` if two protocol conformances match in signature
func areEquivalent(_ conf1: KnownProtocolConformance, _ conf2: KnownProtocolConformance) -> Bool {
    return conf1.protocolName == conf2.protocolName
}

func compare<T>(_ t1: [T], _ t2: [T], _ compare: (T, T) -> Bool) -> Bool {
    return zip(t1, t2).allSatisfy(compare)
}
