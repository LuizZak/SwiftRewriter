import SwiftAST
import KnownType
import SwiftRewriterLib

public enum SwiftStdlibCompoundTypes {
    public static let array = ArrayOfTCompoundType.self
}

public enum ArrayOfTCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "Array")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    private static func typeString() -> String {
        let type = """
            struct Array {
                var count: Int { get }
                
                @_swiftrewriter(mapFrom: addObject(_:))
                mutating func append(_ value: T)

                @_swiftrewriter(mapFrom: addObjects(from:))
                mutating func append(contentsOf sequence: S)

                @_swiftrewriter(mapFrom: removeObject(_:))
                mutating func remove(_ value: T)

                @_swiftrewriter(mapFrom: removeAllObjects(_:))
                mutating func removeAll()

                @_swiftrewriter(mapFrom: indexOfObject(_:))
                func index(of value: T) -> Int

                @_swiftrewriter(mapFrom: containsObject(_:))
                func contains(_ value: T) -> Bool
            }
            """
        
        return type
    }
}

