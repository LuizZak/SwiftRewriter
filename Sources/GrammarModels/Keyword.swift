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
    case `void`
    case `atInterface` = "@interface"
    case `atImplementation` = "@implementation"
    case `atProperty` = "@property"
    case `atEnd` = "@end"
    case `atProtocol` = "@protocol"
    case `typedef`
    case `struct`
    case `enum`
}
