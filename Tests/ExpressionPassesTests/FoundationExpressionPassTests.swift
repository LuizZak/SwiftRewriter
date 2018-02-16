import XCTest
import ExpressionPasses
import SwiftRewriterLib

class FoundationExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = FoundationExpressionPass()
    }
    
    func testIsEqualToString() {
        assertTransformParsed(
            original: "[self.aString isEqualToString:@\"abc\"]",
            expected: .binary(lhs: .postfix(.identifier("self"), .member("aString")),
                              op: .equals,
                              rhs: .constant("abc")))
    }
    
    func testNSStringWithFormat() {
        assertTransformParsed(
            original: "[NSString stringWithFormat:@\"%@\", self]",
            expected: .postfix(.identifier("String"),
                               .functionCall(arguments: [
                                .labeled("format", .constant("%@")),
                                .unlabeled(.identifier("self"))
                                ]))
        )
        assertTransformParsed(
            original: "[NSString stringWithFormat:@\"%@\"]",
            expected: .postfix(.identifier("String"),
                               .functionCall(arguments: [
                                .labeled("format", .constant("%@"))
                                ]))
        )
    }
    
    func testAddObjectsFromArray() {
        assertTransformParsed(
            original: "[array addObjectsFromArray:@[]]",
            expected: .postfix(.postfix(.identifier("array"), .member("addObjects")),
                               .functionCall(arguments: [
                                .labeled("from", .arrayLiteral([]))
                                ]))
        )
    }
    
    func testNSArrayArrayCreator() {
        assertTransformParsed(
            original: "[NSArray array]",
            expected: .postfix(.identifier("NSArray"), .functionCall(arguments: []))
        )
        assertTransformParsed(
            original: "[NSArray array:thing]",
            expected: "NSArray.array(thing)"
        )
    }
    
    func testNSMutableArrayArrayCreator() {
        assertTransformParsed(
            original: "[NSMutableArray array]",
            expected: .postfix(.identifier("NSMutableArray"), .functionCall(arguments: []))
        )
        assertTransformParsed(
            original: "[NSMutableArray array:thing]",
            expected: "NSMutableArray.array(thing)"
        )
    }
    
    func testNSDictionaryDictionaryCreator() {
        assertTransformParsed(
            original: "[NSDictionary dictionary]",
            expected: .postfix(.identifier("NSDictionary"), .functionCall(arguments: []))
        )
        assertTransformParsed(
            original: "[NSDictionary dictionary:thing]",
            expected: "NSDictionary.dictionary(thing)"
        )
    }
    
    func testNSMutableDictionaryDictionaryCreator() {
        assertTransformParsed(
            original: "[NSMutableDictionary dictionary]",
            expected: .postfix(.identifier("NSMutableDictionary"), .functionCall(arguments: []))
        )
        assertTransformParsed(
            original: "[NSMutableDictionary dictionary:thing]",
            expected: "NSMutableDictionary.dictionary(thing)"
        )
    }
    
    func testNSSetSetCreator() {
        assertTransformParsed(
            original: "[NSSet set]",
            expected: .postfix(.identifier("NSSet"), .functionCall(arguments: []))
        )
        assertTransformParsed(
            original: "[NSSet set:thing]",
            expected: "NSSet.set(thing)"
        )
    }
    
    func testNSMutableSetSetCreator() {
        assertTransformParsed(
            original: "[NSMutableSet set]",
            expected: .postfix(.identifier("NSMutableSet"), .functionCall(arguments: []))
        )
        assertTransformParsed(
            original: "[NSMutableSet set:thing]",
            expected: "NSMutableSet.set(thing)"
        )
    }
}
