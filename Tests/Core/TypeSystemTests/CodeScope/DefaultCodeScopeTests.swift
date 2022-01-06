import XCTest
import SwiftAST

@testable import TypeSystem

class DefaultCodeScopeTests: XCTestCase {
    func testFirstDefinitionNamed() {
        let a_1: CodeDefinition = .forLocalIdentifier("a", type: .int, isConstant: false, location: .parameter(index: 0))
        let b: CodeDefinition = .forLocalIdentifier("b", type: .string, isConstant: false, location: .parameter(index: 0))
        let a_2: CodeDefinition = .forGlobalVariable(name: "a", isConstant: false, type: .float)
        let sut = makeSut(definitions: [
            a_1, b, a_2
        ])

        let result = sut.firstDefinition(named: "a")

        XCTAssertTrue(result === a_1)
    }

    func testFirstDefinitionNamed_definitionNotFoundReturnsNil() {
        let sut = makeSut()

        let result = sut.firstDefinition(named: "c")

        XCTAssertNil(result)
    }

    func testFunctionDefinitionsMatching() throws {
        let a_1: CodeDefinition = .forGlobalFunction(
            signature: .init(name: "a")
        )
        let b: CodeDefinition = .forLocalFunctionStatement(
            .init(
                function: LocalFunction(
                    identifier: "b",
                    parameters: [],
                    returnType: .float,
                    body: []
                )
            )
        )
        let a_2: CodeDefinition = .forGlobalFunction(
            signature: .init(name: "a")
        )
        let sut = makeSut(definitions: [a_1, b, a_2])

        let result = sut.functionDefinitions(matching: FunctionIdentifier(name: "a", argumentLabels: []))

        XCTAssertTrue(try result[try: 0] === a_1)
        XCTAssertTrue(try result[try: 1] === a_2)
    }

    func testLocalDefinitions() throws {
        let a_1: CodeDefinition = .forLocalIdentifier("a", type: .int, isConstant: false, location: .parameter(index: 0))
        let b: CodeDefinition = .forLocalIdentifier("b", type: .string, isConstant: false, location: .parameter(index: 0))
        let a_2: CodeDefinition = .forGlobalVariable(name: "a", isConstant: false, type: .float)
        let c: CodeDefinition = .forGlobalFunction(
            signature: .init(name: "c")
        )
        let sut = makeSut(definitions: [
            a_1, b, a_2, c
        ])

        let result = sut.localDefinitions()

        XCTAssertEqual(result.count, 4)
        XCTAssertTrue(result.elementsEqual([a_1, b, a_2, c], by: ===))
    }

    func testRecordDefinition() {
        let a_1: CodeDefinition = .forLocalIdentifier("a", type: .int, isConstant: false, location: .parameter(index: 0))
        let b: CodeDefinition = .forLocalIdentifier("b", type: .string, isConstant: false, location: .parameter(index: 0))
        let a_2: CodeDefinition = .forGlobalVariable(name: "a", isConstant: false, type: .float)
        let c: CodeDefinition = .forGlobalFunction(
            signature: .init(name: "c")
        )
        let sut = makeSut(definitions: [
            a_1, b
        ])

        // Act
        sut.recordDefinition(a_2, overwrite: false)
        
        // Assert
        var result = sut.localDefinitions()
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result.elementsEqual([a_1, b, a_2], by: ===))
        
        // Act 2
        sut.recordDefinition(c, overwrite: false)
        
        // Assert 2
        result = sut.localDefinitions()
        XCTAssertEqual(result.count, 4)
        XCTAssertTrue(result.elementsEqual([a_1, b, a_2, c], by: ===))
    }

    func testRecordDefinition_overwriteTrue_removesCollidingDefinitions() {
        let a_1: CodeDefinition = .forLocalIdentifier("a", type: .int, isConstant: false, location: .parameter(index: 0))
        let b: CodeDefinition = .forLocalIdentifier("b", type: .string, isConstant: false, location: .parameter(index: 0))
        let a_2: CodeDefinition = .forGlobalVariable(name: "a", isConstant: false, type: .float)
        let c: CodeDefinition = .forGlobalFunction(
            signature: .init(name: "c")
        )
        let sut = makeSut(definitions: [
            a_1, b
        ])

        // Act
        sut.recordDefinition(a_2, overwrite: true)
        
        // Assert
        var result = sut.localDefinitions()
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.elementsEqual([b, a_2], by: ===))
        
        // Act 2
        sut.recordDefinition(c, overwrite: true)
        
        // Assert 2
        result = sut.localDefinitions()
        XCTAssertEqual(result.count, 3)
        XCTAssertTrue(result.elementsEqual([b, a_2, c], by: ===))
    }

    func testRemoveLocalDefinitions() throws {
        let a_1: CodeDefinition = .forLocalIdentifier("a", type: .int, isConstant: false, location: .parameter(index: 0))
        let b: CodeDefinition = .forLocalIdentifier("b", type: .string, isConstant: false, location: .parameter(index: 0))
        let a_2: CodeDefinition = .forGlobalVariable(name: "a", isConstant: false, type: .float)
        let c: CodeDefinition = .forGlobalFunction(
            signature: .init(name: "c")
        )
        let sut = makeSut(definitions: [
            a_1, b, a_2, c
        ])

        sut.removeLocalDefinitions()

        let result = sut.localDefinitions()
        XCTAssertEqual(result.count, 0)
    }

    // MARK - Test internals
    private func makeSut(definitions: [CodeDefinition] = []) -> DefaultCodeScope {
        DefaultCodeScope(definitions: definitions)
    }
}
