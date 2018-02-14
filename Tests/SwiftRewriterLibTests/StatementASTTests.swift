//
//  StatementASTTests.swift
//  SwiftRewriterLibTests
//
//  Created by Luiz Fernando Silva on 07/02/2018.
//

import XCTest
import GrammarModels
import SwiftRewriterLib

class StatementASTTests: XCTestCase {
    
    func testDescriptionExpressions() {
       XCTAssertEqual(
            Expression.postfix(.identifier("abc"), .subscript(.constant(.int(1)))).description,
            "abc[1]")
        XCTAssertEqual(
            Expression.postfix(.identifier("abc"), .functionCall(arguments: [.labeled("label", .constant(.int(1))), .unlabeled(.constant(.boolean(true)))])).description,
            "abc(label: 1, true)")
        XCTAssertEqual(
            Expression.binary(lhs: .constant(.int(1)), op: .add, rhs: .constant(.int(4))).description,
            "1 + 4")
    }
    
    func testDescriptionCasts() {
        XCTAssertEqual(
            Expression.cast(.identifier("abc"), type: .pointer(.struct("NSString"))).description,
            "abc as? String")
        XCTAssertEqual(
            Expression.postfix(.cast(.identifier("abc"), type: .pointer(.struct("NSString"))), .member("count")).description,
            "(abc as? String).count")
    }
    
    func testDescriptionOptionalAccess() {
        XCTAssertEqual(
            Expression.postfix(.postfix(.cast(.identifier("abc"), type: .pointer(.struct("NSString"))), .optionalAccess),
                               .member("count")).description,
            "(abc as? String)?.count")
    }
    
    func testDescriptionCostants() {
        XCTAssertEqual(Expression.constant(.int(1)).description, "1")
        XCTAssertEqual(Expression.constant(.float(132.4)).description, "132.4")
        XCTAssertEqual(Expression.constant(.hexadecimal(0xfefe)).description, "0xfefe")
        XCTAssertEqual(Expression.constant(.octal(0o7767)).description, "0o7767")
        XCTAssertEqual(Expression.constant(.string("I'm a string!")).description, "\"I'm a string!\"")
        XCTAssertEqual(Expression.constant(.boolean(true)).description, "true")
        XCTAssertEqual(Expression.constant(.boolean(false)).description, "false")
    }
}
