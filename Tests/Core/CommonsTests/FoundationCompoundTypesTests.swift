import XCTest
import Commons
import SwiftRewriterLib
import Utils

class FoundationCompoundTypesTests: XCTestCase {

    func testCalendarDefinition() {
        let type = FoundationCompoundTypes.nsCalendar.create()
        
        XCTAssertEqual(type.nonCanonicalNames, ["NSCalendar"])
        XCTAssertEqual(type.transformations.count, 3)
        
        assertSignature(type: type, matches: """
            @_swiftrewriter(renameFrom: NSCalendar)
            class Calendar: NSObject {
                @_swiftrewriter(mapFrom: calendarWithIdentifier(_:))
                init(identifier: Calendar.Identifier)
                
                @_swiftrewriter(mapFrom: component(_:fromDate:))
                func component(_ component: Calendar.Component, from date: Date) -> Int
                
                @_swiftrewriter(mapFrom: dateByAddingUnit(_ component: Calendar.Component, value: Int, toDate date: Date, options: NSCalendarOptions) -> Date?)
                func date(byAdding component: Calendar.Component, value: Int, to date: Date) -> Date?
            }
            """)
    }
    
    func testNSArrayDefinition() {
        let type = FoundationCompoundTypes.nsArray.create()
        
        XCTAssertEqual(type.nonCanonicalNames.count, 0)
        XCTAssertEqual(type.transformations.count, 10)
        
        assertSignature(type: type, matches: """
            class NSArray: NSObject, NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration {
                var count: Int { get }
                
                @_swiftrewriter(mapFrom: firstObject())
                var firstObject: Any? { get }
                
                @_swiftrewriter(mapFrom: lastObject())
                var lastObject: Any? { get }
                var description: String { get }
                var sortedArrayHint: Data { get }
                subscript(index: Int) -> Any
                
                
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
            """)
    }
    
    func testNSMutableArrayDefinition() {
        let type = FoundationCompoundTypes.nsMutableArray.create()
        
        XCTAssertEqual(type.supertype?.asSwiftType, "NSArray")
        XCTAssert(type.knownProtocolConformances.isEmpty)
        XCTAssertEqual(type.nonCanonicalNames.count, 0)
        XCTAssertEqual(type.transformations.count, 7)
        
        assertSignature(type: type, matches: """
            class NSMutableArray: NSArray {
                @_swiftrewriter(mapFrom: addObject(_:))
                func add(_ anObject: Any)
                
                @_swiftrewriter(mapFrom: addObjectsFromArray(_:))
                func addObjects(from otherArray: [Any])
                
                @_swiftrewriter(mapFrom: removeObject(_:))
                func remove(_ anObject: Any)
                func exchangeObject(at idx1: Int, withObjectAt idx2: Int)
                func removeAllObjects()
                
                @_swiftrewriter(mapFrom: removeObject(_:inRange:))
                func remove(_ anObject: Any, in range: NSRange)
                
                @_swiftrewriter(mapFrom: removeObjectIdenticalTo(_:inRange:))
                func removeObject(identicalTo anObject: Any, in range: NSRange)
                
                @_swiftrewriter(mapFrom: removeObjectIdenticalTo(_:))
                func removeObject(identicalTo anObject: Any)
                func removeObjects(in otherArray: [Any])
                
                @_swiftrewriter(mapFrom: removeObjectsInRange(_:))
                func removeObjects(in range: NSRange)
                func replaceObjects(in range: NSRange, withObjectsFrom otherArray: [Any], range otherRange: NSRange)
                func replaceObjects(in range: NSRange, withObjectsFrom otherArray: [Any])
                func setArray(_ otherArray: [Any])
                func sort(_ compare: @convention(c) (Any, Any, UnsafeMutableRawPointer?) -> Int, context: UnsafeMutableRawPointer?)
                func sort(using comparator: Selector)
                func insert(_ objects: [Any], at indexes: IndexSet)
                func removeObjects(at indexes: IndexSet)
                func replaceObjects(at indexes: IndexSet, with objects: [Any])
                
                @available(OSX 10.6, *)
                func sort(comparator cmptr: (Any, Any) -> ComparisonResult)
                
                @available(OSX 10.6, *)
                func sort(options opts: NSSortOptions = default, usingComparator cmptr: (Any, Any) -> ComparisonResult)
            }
            """)
    }
    
    func testNSDictionaryDefinition() {
        let type = FoundationCompoundTypes.nsDictionary.create()
        
        XCTAssertEqual(type.nonCanonicalNames.count, 0)
        XCTAssertEqual(type.transformations.count, 0)
        
        assertSignature(type: type, matches: """
            class NSDictionary: NSObject, NSCopying, NSMutableCopying, NSSecureCoding, NSFastEnumeration {
                var count: Int { get }
                var allKeys: [Any] { get }
                var allValues: [Any] { get }
                var description: String { get }
                var descriptionInStringsFileFormat: String { get }
                subscript(key: NSCopying) -> Any? { get }
                subscript(key: String) -> Any? { get }
                
                init()
                func allKeys(for anObject: Any) -> [Any]
                func object(forKey aKey: Any) -> Any?
                func keyEnumerator() -> NSEnumerator
                func description(withLocale locale: Any?) -> String
                func description(withLocale locale: Any?, indent level: Int) -> String
                func isEqual(to otherDictionary: [AnyHashable: Any]) -> Bool
                func objectEnumerator() -> NSEnumerator
                func objects(forKeys keys: [Any], notFoundMarker marker: Any) -> [Any]
                
                @available(OSX 10.13, *)
                func write(to url: URL)
                func keysSortedByValue(using comparator: Selector) -> [Any]
                
                @available(OSX 10.6, *)
                func enumerateKeysAndObjects(_ block: (Any, Any, UnsafeMutablePointer<ObjCBool>) -> Void)
                
                @available(OSX 10.6, *)
                func enumerateKeysAndObjects(options opts: NSEnumerationOptions = default, using block: (Any, Any, UnsafeMutablePointer<ObjCBool>) -> Void)
                
                @available(OSX 10.6, *)
                func keysSortedByValue(comparator cmptr: (Any, Any) -> ComparisonResult) -> [Any]
                
                @available(OSX 10.6, *)
                func keysSortedByValue(options opts: NSSortOptions = default, usingComparator cmptr: (Any, Any) -> ComparisonResult) -> [Any]
                
                @available(OSX 10.6, *)
                func keysOfEntries(passingTest predicate: (Any, Any, UnsafeMutablePointer<ObjCBool>) -> Bool) -> Set<AnyHashable>
                
                @available(OSX 10.6, *)
                func keysOfEntries(options opts: NSEnumerationOptions = default, passingTest predicate: (Any, Any, UnsafeMutablePointer<ObjCBool>) -> Bool) -> Set<AnyHashable>
            }
            """)
    }
    
    func testNSMutableDictionaryDefinition() {
        let type = FoundationCompoundTypes.nsMutableDictionary.create()
        
        XCTAssertEqual(type.supertype?.asSwiftType, "NSDictionary")
        XCTAssert(type.knownProtocolConformances.isEmpty)
        XCTAssertEqual(type.nonCanonicalNames.count, 0)
        XCTAssertEqual(type.transformations.count, 0)
        
        assertSignature(type: type, matches: """
            class NSMutableDictionary: NSDictionary {
                subscript(key: Any) -> Any?
                
                init(capacity numItems: Int)
                func removeObject(forKey aKey: Any)
                func setObject(_ anObject: Any, forKey aKey: NSCopying)
                func addEntries(from otherDictionary: [AnyHashable: Any])
                func removeAllObjects()
                func removeObjects(forKeys keyArray: [Any])
                func setDictionary(_ otherDictionary: [AnyHashable: Any])
            }
            """)
    }
    
    func testNSDateFormatterDefinition() {
        let type = FoundationCompoundTypes.nsDateFormatter.create()
        
        XCTAssertEqual(type.nonCanonicalNames.count, 0)
        XCTAssertEqual(type.transformations.count, 3)
        
        assertSignature(type: type, matches: """
            class DateFormatter: Formatter {
                @_swiftrewriter(mapFrom: dateFormat())
                @_swiftrewriter(mapFrom: setDateFormat(_:))
                var dateFormat: String!
                
                
                @_swiftrewriter(mapFrom: stringFromDate(_:))
                func string(from date: Date) -> String
                
                @_swiftrewriter(mapFrom: dateFromString(_:))
                func date(from string: Date) -> Date?
            }
            """)
    }
    
    func testNSDateDefinition() {
        let type = FoundationCompoundTypes.nsDate.create()
        
        XCTAssertEqual(type.nonCanonicalNames, ["NSDate"])
        XCTAssertEqual(type.transformations.count, 5)
        
        assertSignature(type: type, matches: """
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
                
                @_swiftrewriter(mapToBinary: ==)
                func isEqual(_ other: AnyObject) -> Bool
                
                @_swiftrewriter(mapToBinary: ==)
                func isEqualToDate(_ other: Date) -> Bool
            }
            """)
    }
    
    func testNSLocaleDefinition() {
        let type = FoundationCompoundTypes.nsLocale.create()
        
        XCTAssertEqual(type.nonCanonicalNames, ["NSLocale"])
        XCTAssertEqual(type.transformations.count, 2)
        
        assertSignature(type: type, matches: """
            @_swiftrewriter(renameFrom: NSLocale)
            struct Locale: Hashable, Equatable {
                @_swiftrewriter(mapFrom: localeWithLocaleIdentifier(_:))
                @_swiftrewriter(mapFrom: init(localeIdentifier:))
                init(identifier: String)
            }
            """)
    }
    
    func testNSStringDefinition() {
        let type = FoundationCompoundTypes.nsString.create()
        
        XCTAssertEqual(type.nonCanonicalNames, [])
        XCTAssertEqual(type.transformations.count, 0)
        
        assertSignature(type: type, matches: """
            class NSString: NSObject {
            }
            """)
    }
    
    func testNSMutableStringDefinition() {
        let type = FoundationCompoundTypes.nsMutableString.create()
        
        XCTAssertEqual(type.nonCanonicalNames, [])
        XCTAssertEqual(type.transformations.count, 6)
        
        assertSignature(type: type, matches: """
            class NSMutableString: NSString {
                @_swiftrewriter(mapFrom: stringWithCapacity(_:))
                init(capacity: Int)
                
                @_swiftrewriter(mapFrom: replaceCharactersInRange(_:withString:))
                func replaceCharacters(in range: NSRange, with aString: String)
                
                @_swiftrewriter(mapFrom: insertString(_:atIndex:))
                func insert(_ aString: String, at loc: Int)
                
                @_swiftrewriter(mapFrom: deleteCharactersInRange(_:))
                func deleteCharacters(in range: NSRange)
                
                @_swiftrewriter(mapFrom: appendString(_:))
                func append(_ aString: String)
                func setString(_ aString: String)
                
                @_swiftrewriter(mapFrom: replaceOccurrencesOfString(_:withString:options:range:))
                func replaceOccurrences(of target: String, with replacement: String, options: NSString.CompareOptions = default, range searchRange: NSRange) -> Int
                
                @available(iOS 9.0, *)
                func applyTransform(_ transform: StringTransform, reverse: Bool, range: NSRange, updatedRange resultingRange: NSRangePointer?) -> Bool
            }
            """)
    }
}
