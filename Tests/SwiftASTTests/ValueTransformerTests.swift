import XCTest

import SwiftAST
import struct SwiftAST.ValueTransformer

class ValueTransformerTests: XCTestCase {
    
    func testTransformExpression() {
        let transformer =
            ValueTransformer()
                .decompose()
                .transformIndex(index: 0, transformer: ValueTransformer().removingMemberAccess())
                .asFunctionCall(labels: ["name", "size"])
        let exp = Expression
            .identifier("UIFont")
            .dot("fontWithSize")
            .call([
                .unlabeled(Expression.constant("Helvetica Neue")),
                .labeled("size", .constant(11))
            ])
        
        let result = transformer.transform(value: exp)
        
        XCTAssertEqual(
            result,
            Expression
                .identifier("UIFont")
                .call([
                    .labeled("name", .constant("Helvetica Neue")),
                    .labeled("size", .constant(11))
                ])
        )
    }
    
    func testFailTransformExpression() {
        let transformer =
            ValueTransformer()
                .decompose()
                .transformIndex(index: 0, transformer: ValueTransformer().removingMemberAccess())
                .asFunctionCall(labels: ["name", "size"])
        
        XCTAssertNil(
            transformer.transform(value:
                Expression
                    .identifier("UIFont")
                    .call([
                        .unlabeled(Expression.constant("Helvetica Neue")),
                        .labeled("size", .constant(11))
                    ])
            )
        )
        
        XCTAssertNil(
            transformer.transform(value:
                Expression
                    .identifier("UIFont")
                    .dot("fontWithSize")
                    .call([
                        .unlabeled(Expression.constant("Helvetica Neue")),
                        .labeled("size", .constant(11)),
                        .labeled("weight", .constant("UIFontWeightBold"))
                    ])
            )
        )
        
        XCTAssertNil(
            transformer.transform(value:
                Expression
                    .identifier("UIFont")
                    .dot("fontWithSize")
                    .call()
            )
        )
    }
}
