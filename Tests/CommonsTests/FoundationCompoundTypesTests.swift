import XCTest
import Commons
import SwiftRewriterLib
import Utils

class FoundationCompoundTypesTests: XCTestCase {

    func testCalendarDefinition() {
        let type = FoundationCompoundTypes.nsCalendar.create()
        
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
        
        assertSignature(type: type, matches: """
            struct Date: Hashable, Equatable {
                var timeIntervalSince1970: TimeInterval
                
                
                // Convert from 'static date() -> Date'
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
        
        assertSignature(type: type, matches: """
            struct Locale: Hashable, Equatable {
                // Convert from 'init(localeIdentifier: String)'
                init(identifier: String)
            }
            """)
    }
}
