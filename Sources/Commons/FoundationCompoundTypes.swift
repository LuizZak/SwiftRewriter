import SwiftAST
import KnownType
import MiniLexer

public enum FoundationCompoundTypes {
    public static let nsCalendar = CalendarCompoundType.self
    public static let nsArray = NSArrayCompoundType.self
    public static let nsMutableArray = NSMutableArrayCompoundType.self
    public static let nsDateFormatter = NSDateFormatterCompoundType.self
    public static let nsDate = NSDateCompoundType.self
    public static let nsLocale = NSLocaleCompoundType.self
    public static let nsString = NSStringCompoundType.self
    public static let nsMutableString = NSMutableStringCompoundType.self
}

public enum CalendarCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "Calendar")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func typeString() -> String {
        let type = """
            @_swiftrewriter(renameFrom: NSCalendar)
            class Calendar: NSObject {
                @_swiftrewriter(mapFrom: calendarWithIdentifier(_:))
                init(identifier: Calendar.Identifier)
                
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
    private static var singleton = makeType(from: typeString(), typeName: "NSArray")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func typeString() -> String {
        let type = """
            class NSArray: NSObject, NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration {
                var count: Int { get }
                
                @_swiftrewriter(mapFrom: firstObject())
                var firstObject: Any? { get }
                
                @_swiftrewriter(mapFrom: lastObject())
                var lastObject: Any? { get }
                var description: String { get }
                var sortedArrayHint: Data { get }
                
                
                @_swiftrewriter(mapFrom: objectAtIndex(_:))
                func object(at index: Int) -> Any
                
                @_swiftrewriter(mapFrom: containsObject(_:))
                func contains(_ anObject: Any) -> Bool
                
                @_swiftrewriter(mapFrom: addingObject(_:))
                func adding(_ anObject: Any) -> [Any]
                
                @_swiftrewriter(mapFrom: addingObjectsFromArray(_:))
                func addingObjects(from otherArray: [Any]) -> [Any]
                func componentsJoined(by separator: String) -> String
                func description(withLocale locale: Any?) -> String
                func description(withLocale locale: Any?, indent level: Int) -> String
                func firstObjectCommon(with otherArray: [Any]) -> Any?
                
                @_swiftrewriter(mapFrom: indexOfObject(_:))
                func index(of anObject: Any) -> Int
                
                @_swiftrewriter(mapFrom: indexOf(_:inRange:))
                func index(of anObject: Any, in range: NSRange) -> Int
                
                @_swiftrewriter(mapFrom: indexOfObjectIdenticalTo(_:))
                func indexOfObjectIdentical(to anObject: Any) -> Int
                
                @_swiftrewriter(mapFrom: indexOfObjectIdenticalTo(_:inRange:))
                func indexOfObjectIdentical(to anObject: Any, in range: NSRange) -> Int
                func isEqual(to otherArray: [Any]) -> Bool
                func objectEnumerator() -> NSEnumerator
                func reverseObjectEnumerator() -> NSEnumerator
                func sortedArray(_ comparator: @convention(c) (Any, Any, UnsafeMutableRawPointer?) -> Int, context: UnsafeMutableRawPointer?) -> [Any]
                func sortedArray(_ comparator: @convention(c) (Any, Any, UnsafeMutableRawPointer?) -> Int, context: UnsafeMutableRawPointer?, hint: Data?) -> [Any]
                func sortedArray(using comparator: Selector) -> [Any]
                func subarray(with range: NSRange) -> [Any]
                
                @available(OSX 10.13, *)
                func write(to url: URL)
                func objects(at indexes: IndexSet) -> [Any]
                
                @available(OSX 10.6, *)
                func enumerateObjects(_ block: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Void)
                
                @available(OSX 10.6, *)
                func enumerateObjects(options opts: NSEnumerationOptions, using block: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Void)
                
                @available(OSX 10.6, *)
                func enumerateObjects(at s: IndexSet, options opts: NSEnumerationOptions, using block: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Void)
                
                @available(OSX 10.6, *)
                func indexOfObject(passingTest predicate: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Bool) -> Int
                
                @available(OSX 10.6, *)
                func indexOfObject(options opts: NSEnumerationOptions, passingTest predicate: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Bool) -> Int
                
                @available(OSX 10.6, *)
                func indexOfObject(at s: IndexSet, options opts: NSEnumerationOptions, passingTest predicate: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Bool) -> Int
                
                @available(OSX 10.6, *)
                func indexesOfObjects(passingTest predicate: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Bool) -> IndexSet
                
                @available(OSX 10.6, *)
                func indexesOfObjects(options opts: NSEnumerationOptions, passingTest predicate: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Bool) -> IndexSet
                
                @available(OSX 10.6, *)
                func indexesOfObjects(at s: IndexSet, options opts: NSEnumerationOptions, passingTest predicate: (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Bool) -> IndexSet
                
                @available(OSX 10.6, *)
                func sortedArray(comparator cmptr: (Any, Any) -> ComparisonResult) -> [Any]
                
                @available(OSX 10.6, *)
                func sortedArray(options opts: NSSortOptions, usingComparator cmptr: (Any, Any) -> ComparisonResult) -> [Any]
                
                @available(OSX 10.6, *)
                func index(of obj: Any, inSortedRange r: NSRange, options opts: NSBinarySearchingOptions, usingComparator cmp: (Any, Any) -> ComparisonResult) -> Int
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
                "Found error while parsing NSMutableArray class interface: \(error)"
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

                open func exchangeObject(at idx1: Int, withObjectAt idx2: Int)

                open func removeAllObjects()

                @_swiftrewriter(mapFrom: removeObject(_:inRange:))
                open func remove(_ anObject: Any, in range: NSRange)
                
                @_swiftrewriter(mapFrom: removeObjectIdenticalTo(_:inRange:))
                open func removeObject(identicalTo anObject: Any, in range: NSRange)
                
                @_swiftrewriter(mapFrom: removeObjectIdenticalTo(_:))
                open func removeObject(identicalTo anObject: Any)

                
                open func removeObjects(in otherArray: [Any])
                
                @_swiftrewriter(mapFrom: removeObjectsInRange(_:))
                open func removeObjects(in range: NSRange)

                open func replaceObjects(in range: NSRange, withObjectsFrom otherArray: [Any], range otherRange: NSRange)

                open func replaceObjects(in range: NSRange, withObjectsFrom otherArray: [Any])

                open func setArray(_ otherArray: [Any])

                open func sort(_ compare: @convention(c) (Any, Any, UnsafeMutableRawPointer?) -> Int, context: UnsafeMutableRawPointer?)

                open func sort(using comparator: Selector)

                
                open func insert(_ objects: [Any], at indexes: IndexSet)

                open func removeObjects(at indexes: IndexSet)

                open func replaceObjects(at indexes: IndexSet, with objects: [Any])
                
                @available(OSX 10.6, *)
                open func sort(comparator cmptr: (Any, Any) -> ComparisonResult)

                @available(OSX 10.6, *)
                open func sort(options opts: NSSortOptions = [], usingComparator cmptr: (Any, Any) -> ComparisonResult)
            }
            """
        
        return type
    }
}

public enum NSDateFormatterCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "DateFormatter")
    
    public static func create() -> CompoundedMappingType {
        return singleton
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
    private static var singleton = makeType(from: typeString(), typeName: "Date")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func typeString() -> String {
        let type = """
            @_swiftrewriter(renameFrom: NSDate)
            struct Date: Hashable, Equatable {
                static let distantFuture: Date
                static let distantPast: Date
                
                static var timeIntervalSinceReferenceDate: TimeInterval { get }
                var timeIntervalSinceNow: TimeInterval { get }
                var timeIntervalSince1970: TimeInterval { get }
                
                @_swiftrewriter(mapFrom: date() -> Date)
                init()
                static func date() -> Date
                
                @_swiftrewriter(mapFrom: timeIntervalSinceDate(_:))
                func timeIntervalSince(_ anotherDate: Date) -> TimeInterval
                
                @_swiftrewriter(mapFrom: dateByAddingTimeInterval(_:))
                func addingTimeInterval(_ timeInterval: TimeInterval) -> Date
                
                func earlierDate(_ anotherDate: Date) -> Date
                
                func laterDate(_ anotherDate: Date) -> Date
                
                func compare(_ other: Date) -> ComparisonResult

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
    private static var singleton = makeType(from: typeString(), typeName: "Locale")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func typeString() -> String {
        let type = """
            @_swiftrewriter(renameFrom: NSLocale)
            struct Locale: Hashable, Equatable {
                @_swiftrewriter(mapFrom: localeWithLocaleIdentifier(_:))
                @_swiftrewriter(mapFrom: init(localeIdentifier:))
                init(identifier: String)
            }
            """
        
        return type
    }
}

public enum NSStringCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "NSString")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func typeString() -> String {
        let type = """
            class NSString: NSObject {
            }
            """
        
        return type
    }
}

public enum NSMutableStringCompoundType {
    private static var singleton = makeType(from: typeString(), typeName: "NSMutableString")
    
    public static func create() -> CompoundedMappingType {
        return singleton
    }
    
    static func typeString() -> String {
        let type = """
            class NSMutableString: NSString {
                @_swiftrewriter(mapFrom: stringWithCapacity(_:))
                public init(capacity: Int)
                
                @_swiftrewriter(mapFrom: replaceCharactersInRange(_:withString:))
                open func replaceCharacters(in range: NSRange, with aString: String)
                
                @_swiftrewriter(mapFrom: insertString(_:atIndex:))
                open func insert(_ aString: String, at loc: Int)
                
                @_swiftrewriter(mapFrom: deleteCharactersInRange(_:))
                open func deleteCharacters(in range: NSRange)
                
                @_swiftrewriter(mapFrom: appendString(_:))
                open func append(_ aString: String)
                
                open func setString(_ aString: String)
                
                @_swiftrewriter(mapFrom: replaceOccurrencesOfString(_:withString:options:range:))
                open func replaceOccurrences(of target: String,
                                             with replacement: String,
                                             options: NSString.CompareOptions = [],
                                             range searchRange: NSRange) -> Int
                
                @available(iOS 9.0, *)
                open func applyTransform(_ transform: StringTransform,
                                         reverse: Bool,
                                         range: NSRange,
                                         updatedRange resultingRange: NSRangePointer?) -> Bool
            }
            """
        
        return type
    }
}
