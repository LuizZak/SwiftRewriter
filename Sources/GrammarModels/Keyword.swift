/// A known-keyword type
public enum Keyword: String {
    case `if`
    case `else`
    case `for`
    case `while`
    case `switch`
    case `continue`
    case `break`
    case `return`
    case void
    case atInterface = "@interface"
    case atImplementation = "@implementation"
    case atProperty = "@property"
    case atEnd = "@end"
    case atProtocol = "@protocol"
    case atClass = "@class"
    case typedef
    case `struct`
    case `enum`
    case getter
    case setter
    case atPrivate = "@private"
    case atPublic = "@public"
    case atProtected = "@protected"
    case atPackage = "@package"
    case atOptional = "@optional"
    case atRequired = "@required"
    case atSynthesize = "@synthesize"
    case atDynamic = "@dynamic"
}
