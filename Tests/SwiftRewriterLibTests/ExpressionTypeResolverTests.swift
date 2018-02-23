import XCTest
import SwiftRewriterLib
import SwiftAST

class ExpressionTypeResolverTests: XCTestCase {
    
    func testConstant() {
        assertResolve(.constant(1), expect: .int)
        assertResolve(.constant(1.1), expect: .float)
        assertResolve(.constant(false), expect: .bool)
        assertResolve(.constant("abc"), expect: .string)
        assertResolve(.constant(.nil), expect: .optional(.anyObject))
        assertResolve(.constant(.rawConstant("12.3-a,bc")), expect: .any)
    }
    
    func assertResolve(_ exp: Expression, expect type: SwiftType, file: String = #file, line: Int = #line) {
        let resolver = ExpressionTypeResolver()
        
        let result = resolver.visitExpression(exp)
        
        if result.resolvedType != type {
            recordFailure(withDescription: "Expected expression to resolve as \(result.resolvedType?.description ?? "nil"), but expected \(type)",
                          inFile: file, atLine: line, expected: false)
        }
    }
}
