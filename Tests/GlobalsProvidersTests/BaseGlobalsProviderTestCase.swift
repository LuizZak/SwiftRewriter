import XCTest
import SwiftAST
import SwiftRewriterLib

let cInt = SwiftType.typeName("CInt")
let cFloat = SwiftType.typeName("CFloat")
let cDouble = SwiftType.typeName("CDouble")

class BaseGlobalsProviderTestCase: XCTestCase {
    var sut: GlobalsProvider!
    var globals: DefinitionsSource!
    var types: KnownTypeProvider!
    var typealiases: TypealiasProvider!
    
    override func setUp() {
        super.setUp()
        
        types = nil
        typealiases = nil
    }
    
    func assertDefined(typealiasFrom typealiasName: String,
                       to type: SwiftType,
                       file: String = #file, line: Int = #line) {
        
        guard let actual = typealiases.unalias(typealiasName) else {
            recordFailure(withDescription: "Expected to find typealias with name \(typealiasName)",
                inFile: file, atLine: line, expected: true)
            return
        }
        
        if actual != type {
            recordFailure(
                withDescription: "Expected typealias to be of type \(type), but found \(actual) instead.",
                inFile: file, atLine: line, expected: true)
        }
    }
    
    func assertDefined(variable: String,
                       type: SwiftType,
                       file: String = #file, line: Int = #line) {
        
        guard let definition = globals.definition(named: variable) else {
            recordFailure(withDescription: "Expected to find definition \(variable)",
                inFile: file, atLine: line, expected: true)
            return
        }
        
        guard case let .variable(_, storage) = definition.kind else {
            recordFailure(
                withDescription: "Expected to find a variable defined, but found \(definition.kind) instead",
                inFile: file, atLine: line, expected: true)
            return
        }
        
        if storage.type != type {
            recordFailure(
                withDescription: "Expected variable to be of type \(type), but found \(storage.type) instead.",
                inFile: file, atLine: line, expected: true)
        }
    }
    
    func assertDefined(function: String,
                       paramTypes: [SwiftType],
                       returnType: SwiftType,
                       file: String = #file, line: Int = #line) {
        
        guard let definition = globals.definition(named: function) else {
            recordFailure(withDescription: "Expected to find definition \(function)",
                inFile: file, atLine: line, expected: true)
            return
        }
        
        guard case let .function(signature) = definition.kind else {
            recordFailure(
                withDescription: "Expected to find a function defined, but found \(definition.kind) instead",
                inFile: file, atLine: line, expected: true)
            return
        }
        
        let actualParamTypes = signature.parameters.map { $0.type }
        
        if actualParamTypes != paramTypes {
            let expectedParamsString =
                "(" + paramTypes.map { $0.description }.joined(separator: ", ") + ")"
            
            let actualParamsString =
                "(" + actualParamTypes.map { $0.description }.joined(separator: ", ") + ")"
            
            recordFailure(
                withDescription: """
                Expected function to accept \(expectedParamsString), but it \
                accepts \(actualParamsString) instead.
                """,
                inFile: file, atLine: line, expected: true)
        }
        
        if signature.returnType != returnType {
            recordFailure(
                withDescription: """
                Expected function to return \(returnType), but it returns \
                \(signature.returnType) instead.
                """,
                inFile: file, atLine: line, expected: true)
        }
    }
    
    func assertDefined(typeName: String, file: String = #file, line: Int = #line) {
        if types.knownType(withName: typeName) == nil {
            recordFailure(withDescription: "Expected to find type \(typeName)",
                          inFile: file, atLine: line, expected: true)
        }
    }
    
    func assertDefined(typeName: String,
                       signature: String,
                       file: String = #file, line: Int = #line) {
        
        guard let type = types.knownType(withName: typeName) else {
            recordFailure(withDescription: "Expected to find type \(typeName)",
                inFile: file, atLine: line, expected: true)
            return
        }
        
        let typeString = TypeFormatter.asString(knownType: type)
        
        if typeString != signature {
            recordFailure(
                withDescription: """
                Expected type signature of type \(typeName) to match
                
                \(signature)
                
                but found signature
                
                \(typeString.makeDifferenceMarkString(against: signature))
                """,
                inFile: file, atLine: line, expected: true)
        }
    }
}
