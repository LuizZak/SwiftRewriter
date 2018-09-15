import SwiftAST
import SwiftRewriterLib

public enum FoundationCompoundTypes {
    public static let nsCalendar = CalendarCompoundType.self
    public static let nsArray = NSArrayCompoundType.self
    public static let nsMutableArray = NSMutableArrayCompoundType.self
    public static let nsDateFormatter = NSDateFormatterCompoundType.self
    public static let nsDate = NSDateCompoundType.self
    public static let nsLocale = NSLocaleCompoundType.self
}

public enum CalendarCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing Calendar class interface: \(error)"
            )
        }
    }
    
    static func typeString() -> String {
        let type = """
            class Calendar: NSObject {
                @_swiftrewriter(mapFrom: component(_:fromDate:))
                func component(_ component: Calendar.Component, from date: Date) -> Int
                
                @_swiftrewriter(mapFrom: dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?)
                func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date?
            }
            """
        
        return type
    }
}

public enum NSArrayCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing Calendar class interface: \(error)"
            )
        }
    }
    
    static func typeString() -> String {
        let type = """
            class NSArray: NSObject, NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration {
                var count: Int { get }
                
                @_swiftrewriter(mapFrom: firstObject())
                var firstObject: Any? { get }
                
                @_swiftrewriter(mapFrom: lastObject())
                var lastObject: Any? { get }
                
                
                @_swiftrewriter(mapFrom: objectAtIndex(_:))
                func object(at index: Int) -> Any
                
                @_swiftrewriter(mapFrom: containsObject(_:))
                func contains(_ anObject: Any) -> Bool
            }
            """
        
        return type
    }
}

public enum NSMutableArrayCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            // FIXME: Currently we have to manually transform NSArray from a protocol
            // to a class inheritance; this is due to the way we detect supertypes
            // when completing IncompleteKnownTypes.
            // We need to improve the typing of CompoundTypes to allow callers
            // collect incomplete types which are then completed externally, with
            // all type informations.
            incomplete.modifying { type in
                type.removingConformance(to: "NSArray")
                    .settingSupertype(KnownTypeReference.typeName("NSArray"))
            }
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing Calendar class interface: \(error)"
            )
        }
    }
    
    static func typeString() -> String {
        let type = """
            class NSMutableArray: NSArray {
                @_swiftrewriter(mapFrom: addObject(_:))
                func add(_ anObject: Any)
                
                @_swiftrewriter(mapFrom: addObjectsFromArray(_:))
                func addObjects(from otherArray: [Any])
                
                @_swiftrewriter(mapFrom: removeObject(_:))
                func remove(_ anObject: Any)
            }
            """
        
        return type
    }
}

public enum NSDateFormatterCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing DateFormatter class interface: \(error)"
            )
        }
    }
    
    static func typeString() -> String {
        let type = """
            class DateFormatter: Formatter {
                @_swiftrewriter(mapFrom: dateFormat())
                @_swiftrewriter(mapFrom: setDateFormat(_:))
                var dateFormat: String!
                
                
                @_swiftrewriter(mapFrom: stringFromDate(_:))
                func string(from date: Date) -> String
                
                @_swiftrewriter(mapFrom: dateFromString(_:))
                func date(from string: Date) -> Date?
            }
            """
        
        return type
    }
}

public enum NSDateCompoundType {
    private static var singleton: CompoundedMappingType = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing Date class interface: \(error)"
            )
        }
    }
    
    static func typeString() -> String {
        let type = """
            @_swiftrewriter(renameFrom: NSDate)
            struct Date: Hashable, Equatable {
                var timeIntervalSince1970: TimeInterval


                @_swiftrewriter(mapFrom: date() -> Date)
                init()
                static func date() -> Date

                @_swiftrewriter(mapFrom: dateByAddingTimeInterval(_:))
                func addingTimeInterval(_ timeInterval: TimeInterval) -> Date

                @_swiftrewriter(mapFrom: timeIntervalSinceDate(_:))
                func timeIntervalSince(_ date: Date) -> TimeInterval

                @_swiftrewriter(mapToBinary: ==)
                func isEqual(_ other: AnyObject) -> Bool

                @_swiftrewriter(mapToBinary: ==)
                func isEqualToDate(_ other: Date) -> Bool
            }
            """
        
        return type
    }
}

public enum NSLocaleCompoundType {
    private static var singleton = createType()
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func createType() -> CompoundedMappingType {
        let string = typeString()
        
        do {
            let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: string)
            let type = try incomplete.toCompoundedKnownType()
            
            return type
        } catch {
            fatalError(
                "Found error while parsing Locale class interface: \(error)"
            )
        }
    }
    
    static func typeString() -> String {
        let type = """
            @_swiftrewriter(renameFrom: NSLocale)
            struct Locale: Hashable, Equatable {
                @_swiftrewriter(mapFrom: init(localeIdentifier:))
                init(identifier: String)
            }
            """
        
        return type
    }
}
