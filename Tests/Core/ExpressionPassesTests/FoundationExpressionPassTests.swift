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
        assertNotifiedChange()

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
        assertNotifiedChange()

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
        assertNotifiedChange()

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
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .string)

        res = assertTransformParsed(
            expression: "[NSString stringWithFormat:@\"%@\"]",
            into:
                .identifier("String")
                .call([.labeled("format", .constant("%@"))])
        )
        assertNotifiedChange()

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
        assertNotifiedChange()

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
        assertNotifiedChange()

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
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .optional(.void))
    }

    func testNSArrayArrayCreator() {
        let res = assertTransformParsed(
            expression: "[NSArray array]",
            into: .identifier("NSArray").call()
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("NSArray"))

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSArray array:thing]",
            into: "NSArray.array(thing)"
        )
        assertDidNotNotifyChange()
    }

    func testNSMutableArrayArrayCreator() {
        let res = assertTransformParsed(
            expression: "[NSMutableArray array]",
            into: .identifier("NSMutableArray").call()
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("NSMutableArray"))

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSMutableArray array:thing]",
            into: "NSMutableArray.array(thing)"
        )
        assertDidNotNotifyChange()
    }

    func testNSDictionaryDictionaryCreator() {
        let res = assertTransformParsed(
            expression: "[NSDictionary dictionary]",
            into: .identifier("NSDictionary").call()
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("NSDictionary"))

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSDictionary dictionary:thing]",
            into: "NSDictionary.dictionary(thing)"
        )
        assertDidNotNotifyChange()
    }

    func testNSMutableDictionaryDictionaryCreator() {
        let res = assertTransformParsed(
            expression: "[NSMutableDictionary dictionary]",
            into: .identifier("NSMutableDictionary").call()
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("NSMutableDictionary"))

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSMutableDictionary dictionary:thing]",
            into: "NSMutableDictionary.dictionary(thing)"
        )
        assertDidNotNotifyChange()
    }

    func testNSSetSetCreator() {
        let res = assertTransformParsed(
            expression: "[NSSet set]",
            into: .identifier("NSSet").call()
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("NSSet"))

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSSet set:thing]",
            into: "NSSet.set(thing)"
        )
        assertDidNotNotifyChange()
    }

    func testNSMutableSetSetCreator() {
        let res = assertTransformParsed(
            expression: "[NSMutableSet set]",
            into: .identifier("NSMutableSet").call()
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("NSMutableSet"))

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSMutableSet set:thing]",
            into: "NSMutableSet.set(thing)"
        )
        assertDidNotNotifyChange()
    }

    func testNSDateDateCreator() {
        let res = assertTransformParsed(
            expression: "[NSDate date]",
            into: .identifier("Date").call()
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("NSDate"))

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSDate date:thing]",
            into: "Date.date(thing)"
        )
        assertNotifiedChange()
    }

    func testNSMutableStringCreator() {
        let res = assertTransformParsed(
            expression: "[NSMutableString string]",
            into: .identifier("NSMutableString").call()
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("NSMutableString"))

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSMutableString string:thing]",
            into: "NSMutableString.string(thing)"
        )
        assertDidNotNotifyChange()
    }

    func testNSTimeZoneSystemTimeZone() {
        let res = assertTransformParsed(
            expression: "[NSTimeZone systemTimeZone]",
            into: .identifier("TimeZone").dot("current")
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .typeName("TimeZone"))

        assertTransformParsed(
            expression: "NSTimeZone.systemTimeZone",
            into: .identifier("TimeZone").dot("current")
        )
        assertNotifiedChange()

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSTimeZone systemTimeZone:thing]",
            into: "TimeZone.systemTimeZone(thing)"
        )
        assertNotifiedChange()
    }

    func testNSTimeZoneTransformers() {
        assertTransformParsed(
            expression: "NSTimeZone.localTimeZone",
            into: .identifier("TimeZone").dot("autoupdatingCurrent")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "NSTimeZone.defaultTimeZone",
            into: .identifier("TimeZone").dot("current")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "NSTimeZone.systemTimeZone",
            into: .identifier("TimeZone").dot("current")
        )
        assertNotifiedChange()
    }

    func testNSLocaleTransformers() {
        assertTransformParsed(
            expression: "NSLocale.currentLocale",
            into: .identifier("Locale").dot("current")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "NSLocale.systemLocale",
            into: .identifier("Locale").dot("current")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "NSLocale.autoupdatingCurrentLocale",
            into: .identifier("Locale").dot("autoupdatingCurrent")
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "[NSLocale localeWithLocaleIdentifier:@\"locale\"]",
            into: .identifier("Locale").call([.labeled("identifier", .constant("locale"))])
        )
        assertNotifiedChange()

        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "NSNotALocale.currentLocale",
            into: .identifier("NSNotALocale").dot("currentLocale")
        )
        assertDidNotNotifyChange()

        assertTransformParsed(
            expression: "[NSNotALocale currentLocale]",
            into: .identifier("NSNotALocale").dot("currentLocale").call()
        )
        assertDidNotNotifyChange()
    }

    func testNSNotificationCenterTransform() {
        let res = assertTransformParsed(
            expression: "NSNotificationCenter",
            into: .identifier("NotificationCenter")
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .metatype(for: .typeName("NotificationCenter")))

        assertTransformParsed(
            expression: "[NSNotificationCenter defaultCenter]",
            into: .identifier("NotificationCenter").dot("default")
        )
        assertNotifiedChange()
    }

    func testClassTypeMethod() {
        // Uppercase -> <Type>.self
        assertTransformParsed(
            expression: "[NSObject class]",
            into: .identifier("NSObject").dot("self")
        )
        assertNotifiedChange()

        // lowercase -> type(of: <object>)
        assertTransformParsed(
            expression: "[object class]",
            into:
                .identifier("type")
                .call([.labeled("of", .identifier("object"))])
        )
        assertNotifiedChange()

        assertTransformParsed(
            expression: "[[an expression] class]",
            into:
                .identifier("type")
                .call([.labeled("of", .identifier("an").dot("expression").call())])
        )
        assertNotifiedChange()

        // Test we don't accidentally convert things that do not match [<exp> class]
        // by mistake.
        assertTransformParsed(
            expression: "[NSObject class:aThing]",
            into:
                .identifier("NSObject")
                .dot("class")
                .call([.unlabeled(.identifier("aThing"))])
        )
        assertDidNotNotifyChange()

        assertTransformParsed(
            expression: "[object class:aThing]",
            into:
                .identifier("object")
                .dot("class")
                .call([.unlabeled(.identifier("aThing"))])
        )
        assertDidNotNotifyChange()
    }

    func testNSDateFormatter() {
        let res = assertTransformParsed(
            expression: "NSDateFormatter",
            into: .identifier("DateFormatter")
        )
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .metatype(for: .typeName("DateFormatter")))
    }

    func testNSNumberFormatter() {
        let res = assertTransformParsed(
            expression: "NSNumberFormatter",
            into: .identifier("NumberFormatter")
        )
        assertNotifiedChange()

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
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .metatype(for: .typeName("aTypeName")))

        assertTransform(
            expression: valueExp.copy().dot("class").call(),
            into: .identifier("type").call([.labeled("of", valueExp.copy())])
        )
        assertNotifiedChange()
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
        assertNotifiedChange()

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
        assertNotifiedChange()

        XCTAssertEqual(res.resolvedType, .optional(.bool))
    }

    func testNSCompareResultConversions() {
        assertTransform(
            expression: .identifier("NSOrderedAscending"),
            into: .identifier("ComparisonResult").dot("orderedAscending")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSOrderedDescending"),
            into: .identifier("ComparisonResult").dot("orderedDescending")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSOrderedSame"),
            into: .identifier("ComparisonResult").dot("orderedSame")
        )
        assertNotifiedChange()
    }

    func testNSCalendarUnitConversions() {
        assertTransform(
            expression: .identifier("NSCalendarUnitEra"),
            into: .identifier("Calendar").dot("Component").dot("era")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitYear"),
            into: .identifier("Calendar").dot("Component").dot("year")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitMonth"),
            into: .identifier("Calendar").dot("Component").dot("month")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitDay"),
            into: .identifier("Calendar").dot("Component").dot("day")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitHour"),
            into: .identifier("Calendar").dot("Component").dot("hour")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitMinute"),
            into: .identifier("Calendar").dot("Component").dot("minute")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitSecond"),
            into: .identifier("Calendar").dot("Component").dot("second")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitWeekday"),
            into: .identifier("Calendar").dot("Component").dot("weekday")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitWeekdayOrdinal"),
            into: .identifier("Calendar").dot("Component").dot("weekdayOrdinal")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitQuarter"),
            into: .identifier("Calendar").dot("Component").dot("quarter")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitWeekOfMonth"),
            into: .identifier("Calendar").dot("Component").dot("weekOfMonth")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitWeekOfYear"),
            into: .identifier("Calendar").dot("Component").dot("weekOfYear")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitYearForWeekOfYear"),
            into: .identifier("Calendar").dot("Component").dot("yearForWeekOfYear")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitNanosecond"),
            into: .identifier("Calendar").dot("Component").dot("nanosecond")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitCalendar"),
            into: .identifier("Calendar").dot("Component").dot("calendar")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarUnitTimeZone"),
            into: .identifier("Calendar").dot("Component").dot("timeZone")
        )
        assertNotifiedChange()
    }

    func testNSCalendarIdentifierConversions() {
        assertTransform(
            expression: .identifier("NSCalendarIdentifierGregorian"),
            into: .identifier("Calendar").dot("Identifier").dot("gregorian")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierBuddhist"),
            into: .identifier("Calendar").dot("Identifier").dot("buddhist")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierChinese"),
            into: .identifier("Calendar").dot("Identifier").dot("chinese")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierCoptic"),
            into: .identifier("Calendar").dot("Identifier").dot("coptic")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierEthiopicAmeteMihret"),
            into: .identifier("Calendar").dot("Identifier").dot("ethiopicAmeteMihret")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierEthiopicAmeteAlem"),
            into: .identifier("Calendar").dot("Identifier").dot("ethiopicAmeteAlem")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierHebrew"),
            into: .identifier("Calendar").dot("Identifier").dot("hebrew")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierISO8601"),
            into: .identifier("Calendar").dot("Identifier").dot("ISO8601")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIndian"),
            into: .identifier("Calendar").dot("Identifier").dot("indian")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIslamic"),
            into: .identifier("Calendar").dot("Identifier").dot("islamic")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIslamicCivil"),
            into: .identifier("Calendar").dot("Identifier").dot("islamicCivil")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierJapanese"),
            into: .identifier("Calendar").dot("Identifier").dot("japanese")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierPersian"),
            into: .identifier("Calendar").dot("Identifier").dot("persian")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierRepublicOfChina"),
            into: .identifier("Calendar").dot("Identifier").dot("republicOfChina")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIslamicTabular"),
            into: .identifier("Calendar").dot("Identifier").dot("islamicTabular")
        )
        assertNotifiedChange()

        assertTransform(
            expression: .identifier("NSCalendarIdentifierIslamicUmmAlQura"),
            into: .identifier("Calendar").dot("Identifier").dot("islamicUmmAlQura")
        )
        assertNotifiedChange()
    }
}
