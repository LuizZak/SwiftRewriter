/// Specifies an Objective-C attribute for a property
public enum ObjcPropertyAttribute: Hashable, Codable {
    /// Standard `readonly` property attribute
    public static var readonly: ObjcPropertyAttribute = .attribute("readonly")

    /// Standard `class` property attribute
    public static var `class`: ObjcPropertyAttribute = .attribute("class")
    
    case attribute(String)
    case setterName(String)
    case getterName(String)
    
    public var rawString: String {
        switch self {
        case .attribute(let str), .setterName(let str), .getterName(let str):
            return str
        }
    }
}
