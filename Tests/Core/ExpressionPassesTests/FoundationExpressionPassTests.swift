import SwiftAST
import SwiftRewriterLib
import XCTest

@testable import ExpressionPasses

class FoundationExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        super.setUp()

        sutType = FoundationExpressionPass.self
    }

    func testIsEqualToString() {
        let res = assertTransformParsed(
            expression: "[self.aString isEqualToString:@\"abc\"]",
            into:
                .identifier("self")
                .dot("aString")
                .binary(op: .equals, rhs: .constant("abc"))
        )

        XCTAssertEqual(res.resolvedType, .bool)
    }

    func testNegatedIsEqualToString() {
        let res = assertTransformParsed(
            expression: "![self.aString isEqualToString:@\"abc\"]",
            into:
                .identifier("self")
                .dot("aString")
                .binary(op: .unequals, rhs: .constant("abc"))
        )

        XCTAssertEqual(res.resolvedType, .bool)
    }

    func testIsEqualToStringNullable() {
        let exp =
            Expression
            .identifier("aString").optional()
            .dot("isEqualToString")
            .call([.constant("abc")])

        let res = assertTransform(
            expression: exp,
            into:
                .identifier("aString")
                .binary(op: .equals, rhs: .constant("abc"))
        )

        XCTAssertEqual(res.resolvedType, .bool)
    }

    func testNSStringWithFormat() {
        var res = assertTransformParsed(
            expression: "[NSString stringWithFormat:@\"%@\", self]",
            into:
                .identifier("String")
                .call([
                    .labeled("format", .constant("%@")),
                    .unlabeled(.identifier("self")),
                ])
        )

        XCTAssertEqual(res.resolvedType, .string)

        res = assertTransformParsed(
            expression: "[NSString stringWithFormat:@\"%@\"]",
            into:
                .identifier("String")
                .call([.labeled("format", .constant("%@"))])
        )

        XCTAssertEqual(res.resolvedType, .string)
    }

    func testNSMutableStringWithFormat() {
        let res = assertTransformParsed(
            expression: "[NSMutableString stringWithFormat:@\"%@\", self]",
            into:
                .identifier("NSMutableString")
                .call([
                    .labeled("format", .constant("%@")),
                    .unlabeled(.identifier("self")),
                ])
        )

        XCTAssertEqual(res.resolvedType, .string)
    }

    func testAddObjectsFromArray() {
        let res = assertTransformParsed(
            expression: "[array addObjectsFromArray:@[]]",
            into:
                .identifier("array")
                .dot("addObjects")
                .call([.labeled("from", .arrayLiteral([]))])
        )

        XCTAssertEqual(res.resolvedType, .void)
    }

    func testAddObjectsFromArrayNullable() {
        let exp =
            Expression
            .identifier("array")
            .optional()
            .dot("addObjectsFromArray")
            .call([.arrayLiteral([])])

        let res = assertTransform(
            expression: exp,
            into:
                .identifier("array")
                .optional()
                .dot("addObjects")
                .call([.labeled("from", .arrayLiteral([]))])
        )

        XCTAssertEqual(res.resolvedType, .optional(.void))
    }

    func testNSArrayArrayCreator() {
        let res = assertTransformParsed(
            expression: "[NSArray array]",
            into: .identifier("NSArray").call()
        )

        XCTAssertEqual(res.resolvedType, .typeName("NSArray"))

        // Test unrecognized members are left alone
        assertNoTransformParsed(
            expression: "[NSArray array:thing]"
        )
    }

    func testNSMutableArrayArrayCreator() {
        let res = assertTransformParsed(
            expression: "[NSMutableArray array]",
            into: .identifier("NSMutableArray").call()
        )

        XCTAssertEqual(res.resolvedType, .typeName("NSMutableArray"))

        // Test unrecognized members are left alone
        assertNoTransformParsed(
            expression: "[NSMutableArray array:thing]"
        )
    }

    func testNSDictionaryDictionaryCreator() {
        let res = assertTransformParsed(
            expression: "[NSDictionary dictionary]",
            into: .identifier("NSDictionary").call()
        )

        XCTAssertEqual(res.resolvedType, .typeName("NSDictionary"))

        // Test unrecognized members are left alone
        assertNoTransformParsed(
            expression: "[NSDictionary dictionary:thing]"
        )
    }

    func testNSMutableDictionaryDictionaryCreator() {
        let res = assertTransformParsed(
            expression: "[NSMutableDictionary dictionary]",
            into: .identifier("NSMutableDictionary").call()
        )

        XCTAssertEqual(res.resolvedType, .typeName("NSMutableDictionary"))

        // Test unrecognized members are left alone
        assertNoTransformParsed(
            expression: "[NSMutableDictionary dictionary:thing]"
        )
    }

    func testNSSetSetCreator() {
        let res = assertTransformParsed(
            expression: "[NSSet set]",
            into: .identifier("NSSet").call()
        )

        XCTAssertEqual(res.resolvedType, .typeName("NSSet"))

        // Test unrecognized members are left alone
        assertNoTransformParsed(
            expression: "[NSSet set:thing]"
        )
    }

    func testNSMutableSetSetCreator() {
        let res = assertTransformParsed(
            expression: "[NSMutableSet set]",
            into: .identifier("NSMutableSet").call()
        )

        XCTAssertEqual(res.resolvedType, .typeName("NSMutableSet"))

        // Test unrecognized members are left alone
        assertNoTransformParsed(
            expression: "[NSMutableSet set:thing]"
        )
    }

    func testNSDateDateCreator() {
        let res = assertTransformParsed(
            expression: "[NSDate date]",
            into: .identifier("Date").call()
        )

        XCTAssertEqual(res.resolvedType, .typeName("NSDate"))
        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSDate date:thing]",
            into: .identifier("Date").dot("date").call([.identifier("thing")])
        )
    }

    func testNSMutableStringCreator() {
        let res = assertTransformParsed(
            expression: "[NSMutableString string]",
            into: .identifier("NSMutableString").call()
        )

        XCTAssertEqual(res.resolvedType, .typeName("NSMutableString"))

        // Test unrecognized members are left alone
        assertNoTransformParsed(
            expression: "[NSMutableString string:thing]"
        )
    }

    func testNSTimeZoneSystemTimeZone() {
        let res = assertTransformParsed(
            expression: "[NSTimeZone systemTimeZone]",
            into: .identifier("TimeZone").dot("current")
        )

        XCTAssertEqual(res.resolvedType, .typeName("TimeZone"))

        assertTransformParsed(
            expression: "NSTimeZone.systemTimeZone",
            into: .identifier("TimeZone").dot("current")
        )

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSTimeZone systemTimeZone:thing]",
            into: .identifier("TimeZone").dot("systemTimeZone").call([.identifier("thing")])
        )
    }

    func testNSTimeZoneTransformers() {
        assertTransformParsed(
            expression: "NSTimeZone.localTimeZone",
            into: .identifier("TimeZone").dot("autoupdatingCurrent")
        )

        assertTransformParsed(
            expression: "NSTimeZone.defaultTimeZone",
            into: .identifier("TimeZone").dot("current")
        )

        assertTransformParsed(
            expression: "NSTimeZone.systemTimeZone",
            into: .identifier("TimeZone").dot("current")
        )
    }

    func testNSLocaleTransformers() {
        assertTransformParsed(
            expression: "NSLocale.currentLocale",
            into: .identifier("Locale").dot("current")
        )

        assertTransformParsed(
            expression: "NSLocale.systemLocale",
            into: .identifier("Locale").dot("current")
        )

        assertTransformParsed(
            expression: "NSLocale.autoupdatingCurrentLocale",
            into: .identifier("Locale").dot("autoupdatingCurrent")
        )

        assertTransformParsed(
            expression: "[NSLocale localeWithLocaleIdentifier:@\"locale\"]",
            into: .identifier("Locale").call([.labeled("identifier", .constant("locale"))])
        )

        // Test unrecognized members are left alone
        assertNoTransformParsed(
            expression: "NSNotALocale.currentLocale"
        )

        assertNoTransformParsed(
            expression: "[NSNotALocale currentLocale]"
        )
    }

    func testNSNotificationCenterTransform() {
        let res = assertTransformParsed(
            expression: "NSNotificationCenter",
            into: .identifier("NotificationCenter")
        )

        XCTAssertEqual(res.resolvedType, .metatype(for: .typeName("NotificationCenter")))

        assertTransformParsed(
            expression: "[NSNotificationCenter defaultCenter]",
            into: .identifier("NotificationCenter").dot("default")
        )
    }

    func testClassTypeMethod() {
        // Uppercase -> <Type>.self
        assertTransformParsed(
            expression: "[NSObject class]",
            into: .identifier("NSObject").dot("self")
        )

        // lowercase -> type(of: <object>)
        assertTransformParsed(
            expression: "[object class]",
            into:
                .identifier("type")
                .call([.labeled("of", .identifier("object"))])
        )

        assertTransformParsed(
            expression: "[[an expression] class]",
            into:
                .identifier("type")
                .call([.labeled("of", .identifier("an").dot("expression").call())])
        )

        // Test we don't accidentally convert things that do not match [<exp> class]
        // by mistake.
        assertNoTransformParsed(
            expression: "[NSObject class:aThing]"
        )

        assertNoTransformParsed(
            expression: "[object class:aThing]"
        )
    }

    func testNSDateFormatter() {
        let res = assertTransformParsed(
            expression: "NSDateFormatter",
            into: .identifier("DateFormatter")
        )

        XCTAssertEqual(res.resolvedType, .metatype(for: .typeName("DateFormatter")))
    }

    func testNSNumberFormatter() {
        let res = assertTransformParsed(
            expression: "NSNumberFormatter",
            into: .identifier("NumberFormatter")
        )

        XCTAssertEqual(res.resolvedType, .metatype(for: .typeName("NumberFormatter")))
    }

    func testClassTypeMethodWithResolvedExpressionType() {
        // Tests that if an expression contains either a .metaType or other type
        // assigned to it, that the expression pass takes advantage of that to
        // make better deductions about whether a `[<exp> class]` invocation is
        // a class or instance invocation

        let typeNameExp = Expression.identifier("aTypeName")
        typeNameExp.resolvedType = .metatype(for: .typeName("aTypeName"))

        let valueExp = Expression.identifier("LocalName")
        valueExp.resolvedType = .int

        let res = assertTransform(
            expression: typeNameExp.copy().dot("class").call(),
            into: typeNameExp.copy().dot("self")
        )

        XCTAssertEqual(res.resolvedType, .metatype(for: .typeName("aTypeName")))

        assertTransform(
            expression: valueExp.copy().dot("class").call(),
            into: .identifier("type").call([.labeled("of", valueExp.copy())])
        )
    }

    func testRespondsToSelector() {
        // Tests conversion of 'respondsToSelector' methods

        let res = assertTransform(
            expression:
                .identifier("a")
                .dot("respondsToSelector")
                .call([.identifier("Selector").call([.constant("selector:")])]),
            into:
                .identifier("a")
                .dot("responds")
                .call([
                    .labeled(
                        "to",
                        .identifier("Selector").call([
                            .constant("selector:")
                        ])
                    )
                ])
        )

        XCTAssertEqual(res.resolvedType, .bool)
    }

    func testRespondsToSelectorNullable() {
        // Tests conversion of 'respondsToSelector' methods over nullable types

        let res = assertTransform(
            expression:
                .identifier("a")
                .optional()
                .dot("respondsToSelector")
                .call([.identifier("Selector").call([.constant("selector:")])]),
            into:
                .identifier("a")
                .optional()
                .dot("responds")
                .call([
                    .labeled(
                        "to",
                        .identifier("Selector").call([
                            .constant("selector:")
                        ])
                    )
                ])
        )

        XCTAssertEqual(res.resolvedType, .optional(.bool))
    }

    func testNSCompareResultConversions() {
        assertTransform(
            expression: .identifier("NSOrderedAscending"),
            into: .identifier("ComparisonResult").dot("orderedAscending")
        )

        assertTransform(
            expression: .identifier("NSOrderedDescending"),
            into: .identifier("ComparisonResult").dot("orderedDescending")
        )

        assertTransform(
            expression: .identifier("NSOrderedSame"),
            into: .identifier("ComparisonResult").dot("orderedSame")
        )
    }

    func testNSCalendarUnitConversions() {
        assertTransform(
            expression: .identifier("NSCalendarUnitEra"),
            into: .identifier("Calendar").dot("Component").dot("era")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitYear"),
            into: .identifier("Calendar").dot("Component").dot("year")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitMonth"),
            into: .identifier("Calendar").dot("Component").dot("month")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitDay"),
            into: .identifier("Calendar").dot("Component").dot("day")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitHour"),
            into: .identifier("Calendar").dot("Component").dot("hour")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitMinute"),
            into: .identifier("Calendar").dot("Component").dot("minute")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitSecond"),
            into: .identifier("Calendar").dot("Component").dot("second")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitWeekday"),
            into: .identifier("Calendar").dot("Component").dot("weekday")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitWeekdayOrdinal"),
            into: .identifier("Calendar").dot("Component").dot("weekdayOrdinal")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitQuarter"),
            into: .identifier("Calendar").dot("Component").dot("quarter")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitWeekOfMonth"),
            into: .identifier("Calendar").dot("Component").dot("weekOfMonth")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitWeekOfYear"),
            into: .identifier("Calendar").dot("Component").dot("weekOfYear")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitYearForWeekOfYear"),
            into: .identifier("Calendar").dot("Component").dot("yearForWeekOfYear")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitNanosecond"),
            into: .identifier("Calendar").dot("Component").dot("nanosecond")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitCalendar"),
            into: .identifier("Calendar").dot("Component").dot("calendar")
        )

        assertTransform(
            expression: .identifier("NSCalendarUnitTimeZone"),
            into: .identifier("Calendar").dot("Component").dot("timeZone")
        )
    }

    func testNSCalendarIdentifierConversions() {
        assertTransform(
            expression: .identifier("NSCalendarIdentifierGregorian"),
            into: .identifier("Calendar").dot("Identifier").dot("gregorian")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierBuddhist"),
            into: .identifier("Calendar").dot("Identifier").dot("buddhist")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierChinese"),
            into: .identifier("Calendar").dot("Identifier").dot("chinese")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierCoptic"),
            into: .identifier("Calendar").dot("Identifier").dot("coptic")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierEthiopicAmeteMihret"),
            into: .identifier("Calendar").dot("Identifier").dot("ethiopicAmeteMihret")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierEthiopicAmeteAlem"),
            into: .identifier("Calendar").dot("Identifier").dot("ethiopicAmeteAlem")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierHebrew"),
            into: .identifier("Calendar").dot("Identifier").dot("hebrew")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierISO8601"),
            into: .identifier("Calendar").dot("Identifier").dot("ISO8601")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIndian"),
            into: .identifier("Calendar").dot("Identifier").dot("indian")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIslamic"),
            into: .identifier("Calendar").dot("Identifier").dot("islamic")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIslamicCivil"),
            into: .identifier("Calendar").dot("Identifier").dot("islamicCivil")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierJapanese"),
            into: .identifier("Calendar").dot("Identifier").dot("japanese")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierPersian"),
            into: .identifier("Calendar").dot("Identifier").dot("persian")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierRepublicOfChina"),
            into: .identifier("Calendar").dot("Identifier").dot("republicOfChina")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIslamicTabular"),
            into: .identifier("Calendar").dot("Identifier").dot("islamicTabular")
        )

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIslamicUmmAlQura"),
            into: .identifier("Calendar").dot("Identifier").dot("islamicUmmAlQura")
        )
    }
}
