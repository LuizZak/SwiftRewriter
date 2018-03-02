import XCTest
import ExpressionPasses
import SwiftRewriterLib
import SwiftAST

class FoundationExpressionPassTests: ExpressionPassTestCase {
    override func setUp() {
        sut = FoundationExpressionPass()
    }
    
    func testIsEqualToString() {
        assertTransformParsed(
            expression: "[self.aString isEqualToString:@\"abc\"]",
            into: .binary(lhs: .postfix(.identifier("self"), .member("aString")),
                              op: .equals,
                              rhs: .constant("abc")))
    }
    
    func testNSStringWithFormat() {
        assertTransformParsed(
            expression: "[NSString stringWithFormat:@\"%@\", self]",
            into: .postfix(.identifier("String"),
                               .functionCall(arguments: [
                                .labeled("format", .constant("%@")),
                                .unlabeled(.identifier("self"))
                                ]))
        )
        assertTransformParsed(
            expression: "[NSString stringWithFormat:@\"%@\"]",
            into: .postfix(.identifier("String"),
                               .functionCall(arguments: [
                                .labeled("format", .constant("%@"))
                                ]))
        )
    }
    
    func testAddObjectsFromArray() {
        assertTransformParsed(
            expression: "[array addObjectsFromArray:@[]]",
            into: .postfix(.postfix(.identifier("array"), .member("addObjects")),
                               .functionCall(arguments: [
                                .labeled("from", .arrayLiteral([]))
                                ]))
        )
    }
    
    func testNSArrayArrayCreator() {
        assertTransformParsed(
            expression: "[NSArray array]",
            into: .postfix(.identifier("NSArray"), .functionCall(arguments: []))
        )
        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSArray array:thing]",
            into: "NSArray.array(thing)"
        )
    }
    
    func testNSMutableArrayArrayCreator() {
        assertTransformParsed(
            expression: "[NSMutableArray array]",
            into: .postfix(.identifier("NSMutableArray"), .functionCall(arguments: []))
        )
        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSMutableArray array:thing]",
            into: "NSMutableArray.array(thing)"
        )
    }
    
    func testNSDictionaryDictionaryCreator() {
        assertTransformParsed(
            expression: "[NSDictionary dictionary]",
            into: .postfix(.identifier("NSDictionary"), .functionCall(arguments: []))
        )
        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSDictionary dictionary:thing]",
            into: "NSDictionary.dictionary(thing)"
        )
    }
    
    func testNSMutableDictionaryDictionaryCreator() {
        assertTransformParsed(
            expression: "[NSMutableDictionary dictionary]",
            into: .postfix(.identifier("NSMutableDictionary"), .functionCall(arguments: []))
        )
        assertTransformParsed(
            expression: "[NSMutableDictionary dictionary:thing]",
            into: "NSMutableDictionary.dictionary(thing)"
        )
    }
    
    func testNSSetSetCreator() {
        assertTransformParsed(
            expression: "[NSSet set]",
            into: .postfix(.identifier("NSSet"), .functionCall(arguments: []))
        )
        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSSet set:thing]",
            into: "NSSet.set(thing)"
        )
    }
    
    func testNSMutableSetSetCreator() {
        assertTransformParsed(
            expression: "[NSMutableSet set]",
            into: .postfix(.identifier("NSMutableSet"), .functionCall(arguments: []))
        )
        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSMutableSet set:thing]",
            into: "NSMutableSet.set(thing)"
        )
    }
    
    func testNSDateDateCreator() {
        assertTransformParsed(
            expression: "[NSDate date]",
            into: .postfix(.identifier("NSDate"), .functionCall(arguments: []))
        )
        // Test unrecognized members are left alone
        assertTransformParsed(
            expression: "[NSDate date:thing]",
            into: "NSDate.date(thing)"
        )
    }
    
    func testClassTypeMethod() {
        // Uppercase -> <Type>.self
        assertTransformParsed(
            expression: "[NSObject class]",
            into: .postfix(.identifier("NSObject"), .member("self"))
        )
        // lowercase -> type(of: <object>)
        assertTransformParsed(
            expression: "[object class]",
            into: .postfix(.identifier("type"),
                               .functionCall(arguments: [
                                .labeled("of", .identifier("object"))
                                ]))
        )
        assertTransformParsed(
            expression: "[[an expression] class]",
            into: .postfix(.identifier("type"),
                               .functionCall(arguments: [
                                .labeled("of", .postfix(.postfix(.identifier("an"), .member("expression")), .functionCall(arguments: [])))
                                ]))
        )
        
        // Test we don't accidentally convert things that do not match [<exp> class]
        // by mistake.
        assertTransformParsed(
            expression: "[NSObject class:aThing]",
            into: .postfix(.postfix(.identifier("NSObject"), .member("class")),
                               .functionCall(arguments: [.unlabeled(.identifier("aThing"))]))
        )
        
        assertTransformParsed(
            expression: "[object class:aThing]",
            into: .postfix(.postfix(.identifier("object"), .member("class")),
                               .functionCall(arguments: [.unlabeled(.identifier("aThing"))]))
        )
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
        
        assertTransform(
            expression: .postfix(.postfix(typeNameExp, .member("class")), .functionCall(arguments: [])),
            into: .postfix(typeNameExp, .member("self"))
        )
        
        assertTransform(
            expression: .postfix(.postfix(valueExp, .member("class")), .functionCall(arguments: [])),
            into: .postfix(.identifier("type"),
                               .functionCall(arguments: [
                                .labeled("of", valueExp)
                                ]))
        )
    }
}
