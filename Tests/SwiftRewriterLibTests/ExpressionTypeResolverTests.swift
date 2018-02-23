import XCTest
import SwiftRewriterLib
import SwiftAST

class ExpressionTypeResolverTests: XCTestCase {
    var scope: CodeScope!
    
    override func setUp() {
        scope = nil
    }
    
    func testConstant() {
        assertResolve(.constant(1), expect: .int)
        assertResolve(.constant(1.1), expect: .float)
        assertResolve(.constant(false), expect: .bool)
        assertResolve(.constant("abc"), expect: .string)
        assertResolve(.constant(.nil), expect: .optional(.anyObject))
        assertResolve(.constant(.rawConstant("12.3-a,bc")), expect: .any)
    }
    
    func testUnary() {
        assertResolve(.unary(op: .subtract, .constant(1)), expect: .int)
        assertResolve(.unary(op: .subtract, .constant(1.0)), expect: .float)
        assertResolve(.unary(op: .add, .constant(1)), expect: .int)
        assertResolve(.unary(op: .add, .constant(1.0)), expect: .float)
        assertResolve(.unary(op: .negate, .constant(true)), expect: .bool)
        assertResolve(.unary(op: .subtract, .constant("abc")), expect: nil)
        assertResolve(.unary(op: .bitwiseNot, .constant(1)), expect: .int)
        assertResolve(.unary(op: .bitwiseNot, .constant("abc")), expect: nil)
    }
    
    func testBinary() {
        // Arithmetic
        assertResolve(.binary(lhs: .constant(1), op: .add, rhs: .constant(1)),
                      expect: .int)
        assertResolve(.binary(lhs: .constant(1), op: .multiply, rhs: .constant(1)),
                      expect: .int)
        assertResolve(.binary(lhs: .constant(1), op: .subtract, rhs: .constant(1)),
                      expect: .int)
        assertResolve(.binary(lhs: .constant(1), op: .divide, rhs: .constant(1)),
                      expect: .int)
        assertResolve(.binary(lhs: .constant(1.0), op: .add, rhs: .constant(1.0)),
                      expect: .float)
        assertResolve(.binary(lhs: .constant(false), op: .add, rhs: .constant(true)),
                      expect: nil) // Invalid operands
        
        // Comparison
        assertResolve(.binary(lhs: .constant(1.0), op: .lessThan, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .lessThanOrEqual, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .equals, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .unequals, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .greaterThan, rhs: .constant(1.0)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1.0), op: .greaterThanOrEqual, rhs: .constant(1.0)),
                      expect: .bool)
        
        // Logical
        assertResolve(.binary(lhs: .constant(true), op: .and, rhs: .constant(true)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(true), op: .or, rhs: .constant(true)),
                      expect: .bool)
        assertResolve(.binary(lhs: .constant(1), op: .and, rhs: .constant(2)),
                      expect: nil) // Invalid operands
    }
    
    func testBitwiseBinary() {
        func test(_ op: SwiftOperator, line: Int = #line) {
            assertResolve(.binary(lhs: .constant(1), op: op, rhs: .constant(2)),
                          expect: .int, line: line)
            assertResolve(.binary(lhs: .constant(2.0), op: op, rhs: .constant(2.0)),
                          expect: nil, line: line) // Invalid operands
            assertResolve(.binary(lhs: .constant(true), op: op, rhs: .constant(2)),
                          expect: nil, line: line) // Invalid operands
        }
        
        test(.bitwiseAnd)
        test(.bitwiseOr)
        test(.bitwiseXor)
        
        assertResolve(.binary(lhs: .constant(1), op: .bitwiseNot, rhs: .constant(2)),
                      expect: nil) // Bitwise not is a unary operator
    }
    
    func testNullCoallesce() {
        // Null-coallesce with non-null right-handside
        assertResolve(.binary(lhs: makeAnOptional(.constant(1)),
                              op: .nullCoallesce,
                              rhs: .constant(1)),
                      expect: .int)
        
        // Null-coallesce with nullable right-handside
        assertResolve(.binary(lhs: makeAnOptional(.constant(1)),
                              op: .nullCoallesce,
                              rhs: makeAnOptional(.constant(1))),
                      expect: .optional(.int))
        
        // Nonnull type
        assertResolve(.binary(lhs: .constant(1), op: .nullCoallesce, rhs: .constant(1)),
                      expect: .int)
    }
    
    func testIdentifier() {
        let ident = IdentifierExpression(identifier: "i")
        makeScoped(exp: ident, withVars: CodeDefinition(name: "i", type: .int))
        
        assertResolve(ident, expect: .int)
    }
    
    func testIdentifierTypePropagation() {
        let lhs = IdentifierExpression(identifier: "a")
        let rhs = IdentifierExpression(identifier: "b")
        let exp = Expression.binary(lhs: lhs, op: .add, rhs: rhs)
        
        makeScoped(exp: exp, withVars: CodeDefinition(name: "a", type: .int), CodeDefinition(name: "b", type: .int))
        
        assertResolve(exp, expect: .int)
    }
    
    func testDefinitionCollecting() {
        let stmt = Statement.variableDeclarations([
            StatementVariableDeclaration(identifier: "a", type: .int, ownership: .strong, isConstant: false, initialization: nil)
            ])
        makeScoped(statement: stmt)
        
        visitWithSut(stmt)
        
        XCTAssertNotNil(scope.definition(named: "a"))
        XCTAssertEqual(scope.definition(named: "a")?.name, "a")
        XCTAssertEqual(scope.definition(named: "a")?.type, .int)
    }
}

extension ExpressionTypeResolverTests {
    func makeAnOptional(_ exp: Expression) -> Expression {
        let typeSystem = DefaultTypeSystem()
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        
        _=resolver.visitExpression(exp)
        
        exp.resolvedType = exp.resolvedType.map { .optional($0) }
        return exp
    }
    
    func makeScoped(exp: Expression, withVars decl: CodeDefinition...) {
        if exp.parent == nil {
            makeScoped(exp: exp)
        }
        for decl in decl {
            exp.nearestScope.recordDefinition(decl)
        }
    }
    
    func makeScoped(exp: Expression) {
        let scope = CompoundStatement(statements: [.expression(exp)])
        XCTAssert(exp.isDescendent(of: scope))
        
        self.scope = scope // Hold value strongly in memory
    }
    
    func makeScoped(statement: Statement) {
        let scope = CompoundStatement(statements: [statement])
        XCTAssert(statement.isDescendent(of: scope))
        
        self.scope = scope // Hold value strongly in memory
    }
    
    func visitWithSut(_ stmt: Statement) {
        let typeSystem = DefaultTypeSystem()
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        resolver.ignoreResolvedExpressions = true
        
        _=stmt.accept(resolver)
    }
    
    func assertResolve(_ exp: Expression, expect type: SwiftType?, file: String = #file, line: Int = #line) {
        let typeSystem = DefaultTypeSystem()
        let resolver = ExpressionTypeResolver(typeSystem: typeSystem)
        resolver.ignoreResolvedExpressions = true
        
        let result = resolver.visitExpression(exp)
        
        if result.resolvedType != type {
            recordFailure(withDescription: "Expected expression to resolve as \(type?.description ?? "nil"), but received \(result.resolvedType?.description ?? "nil")",
                inFile: file, atLine: line, expected: false)
        }
    }
}
