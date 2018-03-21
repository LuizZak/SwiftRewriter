import XCTest
import SwiftAST
import SwiftRewriterLib
import TestCommons

class SwiftTypeParserTests: XCTestCase {
    func testParseIdentifierType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type"),
                           SwiftType.typeName("Type"))
    }
    
    func testParseOptionalIdentifierType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type?"),
                           SwiftType.optional("Type"))
    }
    
    func testParseOptionalImplicitlyUnwrappedOptionalIdentifierType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type?!"),
                           SwiftType.implicitUnwrappedOptional(.optional("Type")))
    }
    
    func testNestedType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type1.Type2"),
                           SwiftType.nested(.typeName("Type1"), .typeName("Type2")))
    }
    
    func testParseEmptyTuple() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "()"),
                           SwiftType.void)
    }
    
    func testParseTupleType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(Type1, Type2)"),
                           SwiftType.tuple([.typeName("Type1"),
                                            .typeName("Type2")]))
    }
    
    func testParseTupleInTupleType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "((Type1, Type2), (Type3, Type4))"),
                           SwiftType.tuple([.tuple([.typeName("Type1"), .typeName("Type2")]),
                                            .tuple([.typeName("Type3"), .typeName("Type4")])]))
    }
    
    func testParseTupleTypeWithLabels() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(label1: Type1, label2: Type2)"),
                           SwiftType.tuple([.typeName("Type1"),
                                            .typeName("Type2")]))
    }
    
    func testParseBlockType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(Type1) -> Type2"),
                           SwiftType.block(returnType: .typeName("Type2"),
                                           parameters: [.typeName("Type1")]))
    }
    
    func testParseBlockWithParameterLabels() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(_ param: Type1, param2: Type2) -> Type2"),
                           SwiftType.block(returnType: .typeName("Type2"),
                                           parameters: [.typeName("Type1"),
                                                        .typeName("Type2")]))
    }
    
    func testParseBlockArgumentWithInOut() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(inout Type1) -> Type2"),
                           SwiftType.block(returnType: .typeName("Type2"),
                                           parameters: [.typeName("Type1")]))
    }
    
    func testParseBlockArgumentWithInOutAndParameterName() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(name: inout Type1) -> Type2"),
                           SwiftType.block(returnType: .typeName("Type2"),
                                           parameters: [.typeName("Type1")]))
    }
    
    func testParseBlockArgumentWithInOutAndParameterNameAndLabel() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(label name: inout Type1) -> Type2"),
                           SwiftType.block(returnType: .typeName("Type2"),
                                           parameters: [.typeName("Type1")]))
    }
    
    func testParseArray() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "[Type1]"),
                           SwiftType.array(.typeName("Type1")))
    }
    
    func testParseDirectory() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "[Type1: Type2]"),
                           SwiftType.dictionary(key: .typeName("Type1"),
                                                value: .typeName("Type2")))
    }
    
    func testParseOptionalBlock() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(() -> ())?"),
                           SwiftType.optional(.block(returnType: .void, parameters: [])))
    }
    
    func testParseGenericType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type<A>"),
                           SwiftType.generic("Type", parameters: [.typeName("A")]))
    }
    
    func testParseGenericTypeWitihinGenericType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type<A<B>>"),
                           SwiftType.generic("Type", parameters: [.generic("A", parameters: [.typeName("B")])]))
    }
    
    func testParseGenericTypeWithTupleType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Type<(A, B)>"),
                           SwiftType.generic("Type", parameters: [.tuple([.typeName("A"), .typeName("B")])]))
    }
    
    func testParseBlockTypeTakingBlockType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(() -> ()) -> ()"),
                           SwiftType.block(returnType: .void, parameters: [.block(returnType: .void, parameters: [])]))
    }
    
    func testMetatypeOfIdentifier() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "TypeA.Type"),
                           SwiftType.metatype(for: .typeName("TypeA")))
    }
    
    func testProtocolMetatypeOfIdentifier() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "TypeA.Protocol"),
                           SwiftType.metatype(for: .typeName("TypeA")))
    }
    
    func testMetatypeOfNestedIdentifier() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "TypeA.TypeB.Type"),
                           SwiftType.metatype(for: SwiftType.nested(.typeName("TypeA"), .typeName("TypeB"))))
    }
    
    func testMetatypeOfOptionalType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "TypeA?.Type"),
                           SwiftType.metatype(for: .optional(.typeName("TypeA"))))
    }
    
    func testMetatypeOfOptionalTypeWithinTupleType() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "(TypeA?).Type"),
                           SwiftType.metatype(for: .optional(.typeName("TypeA"))))
    }
    
    func testParseProtocolComposition() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "TypeA & TypeB"),
                           SwiftType.protocolComposition([.typeName("TypeA"),
                                                          .typeName("TypeB")]))
        try XCTAssertEqual(SwiftTypeParser.parse(from: "TypeA & TypeB & TypeC"),
                           SwiftType.protocolComposition([.typeName("TypeA"),
                                                          .typeName("TypeB"),
                                                          .typeName("TypeC")]))
    }
    
    func testVoidParsesAsTypeAliasOfEmptyTuple() throws {
        try XCTAssertEqual(SwiftTypeParser.parse(from: "Void"),
                           SwiftType.tuple([]))
    }
    
    func testParseExtraCharacterMessage() throws {
        XCTAssertThrowsError(try SwiftTypeParser.parse(from: "Type<(A, B))>"))
    }
    
    func testCannotUseInoutAsParameterName() throws {
        XCTAssertThrowsError(try SwiftTypeParser.parse(from: "(inout: Type1) -> Type2"))
        XCTAssertThrowsError(try SwiftTypeParser.parse(from: "(label inout: Type1) -> Type2"))
    }
    
    func testCannotUseInoutAsParameterLabel() throws {
        XCTAssertThrowsError(try SwiftTypeParser.parse(from: "(inout name: Type1) -> Type2"))
    }
    
    func testParseProtocolCompositionInBlockArgument() throws {
        XCTAssertThrowsError(try SwiftTypeParser.parse(from: "(TypeA & TypeB) -> )"))
    }
    
    func testRandomTypeParsing() throws {
        for i in 0..<1000 {
            let type = SwiftTypePermutator.permutate(seed: 127 * i + i).normalized
            let typeString = type.description
            
            do {
                let parsed = try SwiftTypeParser.parse(from: typeString).normalized
                
                XCTAssertEqual(type, parsed)
                if type != parsed {
                    break
                }
            } catch {
                let coder = JSONEncoder()
                let data = try coder.encode(type)
                let str = String(data: data, encoding: .utf8)!
                XCTFail("Failed on type \(typeString): \(error)\n\nSerialized type:\n\(str)")
                return
            }
            
            break
        }
    }
}

class SwiftTypePermutator {
    
    public static func permutate(seed: Int) -> SwiftType {
        let mersenne = MersenneTwister(seed: UInt32(seed))
        let context = Context(mersenne: mersenne)
        
        return SwiftTypePermutator(probability: 1, context: context).swiftType() ?? .void
    }
    
    /// Probability, from 0-1, that calling `swiftType()` will generate a non-nil
    /// return.
    private let probability: Double
    
    /// Shared mutable context for all child permutators
    private let context: Context
    
    private init(probability: Double, context: Context) {
        self.probability = probability
        self.context = context
    }
    
    private func swiftType() -> SwiftType? {
        if probability <= 0 {
            return nil
        }
        
        let res: SwiftType? = oneOf(composable, tuple, block, { nil })
        
        return res.map(addTrailingTypeMaybe)
    }
    
    private func composable() -> SwiftType {
        if chanceFromProbability() {
            let types = randomProduceArray(biasToEmpty: 0.3) { branchProbably(damp: $0)?.composable() }
            
            if types.count == 1 {
                return types[0]
            }
            if types.count == 0 {
                return nestable()
            }
            
            return .protocolComposition(types)
        }
        
        return nestable()
    }
    
    private func nestable() -> SwiftType {
        let base = oneOf(biasLeft: 1 - probability, identifier, generic)
        let sub = oneOf(biasLeft: 1 - probability, identifier, generic)
        
        return SwiftType.nested(base, sub)
    }
    
    private func identifier() -> SwiftType {
        return .typeName(randomTypeName())
    }
    
    private func tuple() -> SwiftType {
        return .tuple(randomTypes())
    }
    
    private func block() -> SwiftType {
        // Produce tuple for parameters
        let params = randomTypes()
        let ret = randomSubtype() ?? .void
        
        return SwiftType.block(returnType: ret, parameters: params)
    }
    
    private func generic() -> SwiftType {
        let params = randomTypes()
        if params.count == 0 {
            return .typeName(randomTypeName())
        }
        
        return .generic(randomTypeName(), parameters: params)
    }
    
    private func addTrailingTypeMaybe(_ type: SwiftType) -> SwiftType {
        return
            oneOf({ self.branch().addTrailingTypeMaybe(.metatype(for: type)) },
                  { self.branch().addTrailingTypeMaybe(.optional(type)) },
                  { self.branch().addTrailingTypeMaybe(.implicitUnwrappedOptional(type)) },
                  { type })
    }
    
    // Helper generators
    
    private func randomTypeName() -> String {
        context.counter += 1
        return "Type\(context.counter)"
    }
    
    private func randomTypes() -> [SwiftType] {
        return randomProduceArray { branch(damp: $0).swiftType() }
    }
    
    private func randomProduceArray<T>(biasToEmpty: Double = 0, _ producer: (Double) -> T?) -> [T] {
        var values: [T] = []
        var budget = probability * (1 - biasToEmpty)
        
        while chanceNormal(bellow: budget) {
            guard let v = producer(budget) else {
                break
            }
            
            values.append(v)
            
            budget *= 0.7
        }
        
        return values
    }
    
    // MARK: Branching and random choosing
    
    private func oneOf<T>(biasLeft bias: Double = 0, _ generators: () -> T...) -> T {
        let r = random(upTo: generators.count)
        let index = Int(Double(r) * (1 - bias))
        
        return generators[min(generators.count - 1, index)]()
    }
    
    private func randomSubtype(damp: Double = 0.8) -> SwiftType? {
        return branch(damp: damp).swiftType()
    }
    
    private func branch(damp: Double = 0.8) -> SwiftTypePermutator {
        return
            SwiftTypePermutator(probability: probability * min(1, max(0, damp)),
                                context: context)
    }
    
    private func branchProbably(damp: Double = 0.8) -> SwiftTypePermutator? {
        if chanceNormal(bellow: probability * damp) {
            return
                SwiftTypePermutator(probability: probability * min(1, max(0, damp)),
                                    context: context)
        }
        
        return nil
    }
    
    // MARK: Randomizer stuff
    
    private func chanceFromProbability(bias: Double = 0) -> Bool {
        return chanceNormal(bellow: probability * (1 - bias))
    }
    
    private func chanceNormal(bellow: Double) -> Bool {
        return randomNormal() <= bellow
    }
    
    private func random(upTo max: Int) -> Int {
        return Int(context.mersenne.random()) % (max + 1)
    }
    
    private func randomNormal() -> Double {
        let value = context.mersenne.random()
        let double = Double(value) / Double(UInt32.max)
        
        return double
    }
    
    // MARK: Context
    
    private class Context {
        var mersenne: MersenneTwister
        
        // Used to generate unique identifier type names "Type1", "Type2", etc.
        var counter: Int = 0
        
        init(mersenne: MersenneTwister) {
            self.mersenne = mersenne
        }
    }
}
