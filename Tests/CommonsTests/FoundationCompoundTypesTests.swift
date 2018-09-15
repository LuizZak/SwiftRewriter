import XCTest
import Commons
import SwiftRewriterLib
import Utils

class FoundationCompoundTypesTests: XCTestCase {

    func testCalendarDefinition() {
        let type = FoundationCompoundTypes.nsCalendar.create()
        
        XCTAssertEqual(type.nonCanonicalNames.count, 0)
        XCTAssertEqual(type.transformations.count, 2)
        
        assertSignature(type: type, matches: """
            class Calendar: NSObject {
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
        XCTAssertEqual(type.transformations.count, 4)
        
        assertSignature(type: type, matches: """
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
            """)
    }
    
    func testNSMutableArrayDefinition() {
        let type = FoundationCompoundTypes.nsMutableArray.create()
        
        XCTAssertEqual(type.nonCanonicalNames.count, 0)
        XCTAssertEqual(type.transformations.count, 3)
        
        assertSignature(type: type, matches: """
            class NSMutableArray: NSArray {
                @_swiftrewriter(mapFrom: addObject(_:))
                func add(_ anObject: Any)
                
                @_swiftrewriter(mapFrom: addObjectsFromArray(_:))
                func addObjects(from otherArray: [Any])
                
                @_swiftrewriter(mapFrom: removeObject(_:))
                func remove(_ anObject: Any)
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
            """)
    }
    
    func testNSLocaleDefinition() {
        let type = FoundationCompoundTypes.nsLocale.create()
        
        XCTAssertEqual(type.nonCanonicalNames, ["NSLocale"])
        XCTAssertEqual(type.transformations.count, 1)
        
        assertSignature(type: type, matches: """
            @_swiftrewriter(renameFrom: NSLocale)
            struct Locale: Hashable, Equatable {
                @_swiftrewriter(mapFrom: init(localeIdentifier:))
                init(identifier: String)
            }
            """)
    }
}
