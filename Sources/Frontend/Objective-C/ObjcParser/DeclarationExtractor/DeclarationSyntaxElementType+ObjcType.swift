import ObjcGrammarModels

public extension GenericTypeParameterSyntax.Variance {
    var asObjcGenericTypeVariance: ObjcGenericTypeVariance {
        switch self {
        case .covariant:
            return .covariant
        case .contravariant:
            return .contravariant
        }
    }
}

public extension NullabilitySpecifierSyntax {
    var asObjcNullabilitySpecifier: ObjcNullabilitySpecifier {
        switch self {
        case .nonnull:
            return .nonnull
        case .nullResettable:
            return .nullResettable
        case .nullUnspecified:
            return .nullUnspecified
        case .nullable:
            return .nullable
        }
    }
}

public extension TypeQualifierSyntax {
    var asObjcTypeQualifier: ObjcTypeQualifier {
        switch self {
        case .const:
            return .const
        case .volatile:
            return .volatile
        case .restrict:
            return .restrict
        case .atomic:
            return .atomic
        case .protocolQualifier(let value):
            return .protocolQualifier(value.asObjcProtocolQualifier)
        }
    }
}

public extension ProtocolQualifierSyntax {
    var asObjcProtocolQualifier: ObjcProtocolQualifier {
        switch self {
        case .bycopy:
            return .bycopy
        case .byref:
            return .byref
        case .in:
            return .in
        case .inout:
            return .inout
        case .oneway:
            return .oneway
        case .out:
            return .out
        }
    }
}

public extension ArcBehaviourSpecifierSyntax {
    var asObjcArcBehaviorSpecifier: ObjcArcBehaviorSpecifier {
        switch self {
        case .autoreleasingQualifier:
            return .autoreleasing
        case .strongQualifier:
            return .strong
        case .unsafeUnretainedQualifier:
            return .unsafeUnretained
        case .weakQualifier:
            return .weak
        }
    }
}

public extension FunctionSpecifierSyntax {
    var asObjcFunctionSpecifier: ObjcFunctionSpecifier {
        switch self {
        case .inline:
            return .inline
        case .noreturn:
            return .noReturn
        case .gccInline:
            return .inline
        case .stdcall:
            return .stdCall
        case .declspec(_, let ident):
            return .declspec(ident.identifier)
        }
    }
}

public extension IBOutletQualifierSyntax {
    var asObjcIBOutletQualifier: ObjcIBOutletQualifier {
        switch self {
        case .ibOutletCollection(_, let value):
            return .ibCollection(value.identifier)
        case .ibOutlet:
            return .ibOutlet
        }
    }
}
