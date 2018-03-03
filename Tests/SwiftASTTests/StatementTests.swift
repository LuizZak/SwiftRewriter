//
//  StatementTests.swift
//  SwiftASTTests
//
//  Created by Luiz Fernando Silva on 03/03/2018.
//

import XCTest
import SwiftAST

class StatementTests: XCTestCase {
    func testCreatingCompoundStatementWithLiteralProperlySetsParents() {
        let brk = BreakStatement()
        let stmt: CompoundStatement = [
            brk
        ]
        
        XCTAssert(brk.parent === stmt)
    }
}
