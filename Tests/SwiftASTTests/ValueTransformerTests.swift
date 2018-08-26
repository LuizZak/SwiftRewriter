import XCTest

import SwiftAST
import struct SwiftAST.ValueTransformer

class ValueTransformerTests: XCTestCase {
    
    func testTransformExpression() {
        let transformer =
            ValueTransformer()
                .decompose()
                .transformIndex(index: 0, transformer: ValueTransformer()
                    .removingMemberAccess()
                    .validate { $0.resolvedType == .metatype(for: "UIFont") }
                )
                .asFunctionCall(labels: ["name", "size"])
        let exp = Expression
            .identifier("UIFont")
            .typed(.metatype(for: "UIFont"))
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
            ValueTransformer<Expression, Expression>()
                .decompose()
                .transformIndex(index: 0, transformer: ValueTransformer()
                    .removingMemberAccess()
                    .validate { $0.resolvedType == .metatype(for: "UIFont") }
                )
                .asFunctionCall(labels: ["name", "size"])
        
        // Incorrect type (validate closure)
        XCTAssertNil(
            transformer.transform(value:
                Expression
                    .identifier("UIFont")
                    .typed("SomeOtherType")
                    .dot("fontWithSize")
                    .call([
                        .unlabeled(Expression.constant("Helvetica Neue")),
                        .labeled("size", .constant(11)),
                        .labeled("weight", .constant("UIFontWeightBold"))
                    ])
            )
        )
        
        // Missing method member access
        XCTAssertNil(
            transformer.transform(value:
                Expression
                    .identifier("UIFont")
                    .typed(.metatype(for: "UIFont"))
                    .call([
                        .unlabeled(Expression.constant("Helvetica Neue")),
                        .labeled("size", .constant(11))
                    ])
            )
        )
        
        // Too many parameters
        XCTAssertNil(
            transformer.transform(value:
                Expression
                    .identifier("UIFont")
                    .typed(.metatype(for: "UIFont"))
                    .dot("fontWithSize")
                    .call([
                        .unlabeled(Expression.constant("Helvetica Neue")),
                        .labeled("size", .constant(11)),
                        .labeled("weight", .constant("UIFontWeightBold"))
                    ])
            )
        )
        
        // Too few parameters
        XCTAssertNil(
            transformer.transform(value:
                Expression
                    .identifier("UIFont")
                    .typed("TypeName")
                    .dot("fontWithSize")
                    .call()
            )
        )
    }
    
    func testValidate() {
        let transformer =
            ValueTransformer<Int, String>(keyPath: \.description)
                .validate { $0 != "2" }
        
        XCTAssertEqual(transformer.transform(value: 0), "0")
        XCTAssertEqual(transformer.transform(value: 1), "1")
        XCTAssertNil(transformer.transform(value: 2))
    }
}
