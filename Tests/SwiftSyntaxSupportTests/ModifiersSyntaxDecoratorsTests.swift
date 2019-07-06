import XCTest
import TestCommons
@testable import SwiftSyntaxSupport
@testable import Intentions
import SwiftAST

class ModifiersSyntaxDecoratorsTests: XCTestCase {
    func testDefaultModifiersDecoratorApplier() {
        let sut = ModifiersSyntaxDecoratorApplier.makeDefaultDecoratorApplier()
        
        var decorators = sut.decorators.makeIterator()
        
        XCTAssert(decorators.next() is AccessLevelModifiersDecorator)
        XCTAssert(decorators.next() is PropertySetterAccessModifiersDecorator)
        XCTAssert(decorators.next() is ProtocolOptionalModifiersDecorator)
        XCTAssert(decorators.next() is StaticModifiersDecorator)
        XCTAssert(decorators.next() is OverrideModifiersDecorator)
        XCTAssert(decorators.next() is ConvenienceInitModifiersDecorator)
        XCTAssert(decorators.next() is MutatingModifiersDecorator)
        XCTAssert(decorators.next() is OwnershipModifiersDecorator)
        XCTAssertNil(decorators.next())
    }
    
    func testMutatingModifiersDecorator() {
        let type = StructGenerationIntention(typeName: "Struct")
        withExtendedLifetime(type) {
            let method = MethodGenerationIntention(isStatic: false,
                                                   name: "method",
                                                   returnType: .int,
                                                   parameters: [])
            method.signature.isMutating = true
            type.addMethod(method)
            method.type = type
            
            let sut = MutatingModifiersDecorator()
            
            assert(decorator: sut,
                   element: .intention(method),
                   producesModifiers: ["mutating"])
        }
    }
    
    func testMutatingModifiersDecoratorDoesNotProduceMutatingForClassTypes() {
        let type = ClassGenerationIntention(typeName: "class")
        withExtendedLifetime(type) {
            let method = MethodGenerationIntention(isStatic: false,
                                                   name: "method",
                                                   returnType: .int,
                                                   parameters: [])
            method.signature.isMutating = true
            type.addMethod(method)
            method.type = type
            
            let sut = MutatingModifiersDecorator()
            
            assert(decorator: sut, element: .intention(method), producesModifiers: [])
        }
    }
    
    func testMutatingModifiersDecoratorDoesNotProduceMutatingForNonMutatingMethods() {
        let type = StructGenerationIntention(typeName: "Struct")
        withExtendedLifetime(type) {
            let method = MethodGenerationIntention(isStatic: false,
                                                   name: "method",
                                                   returnType: .int,
                                                   parameters: [])
            method.signature.isMutating = false
            type.addMethod(method)
            method.type = type
            
            let sut = MutatingModifiersDecorator()
            
            assert(decorator: sut, element: .intention(method), producesModifiers: [])
        }
    }
    
    func testStaticModifiersDecoratorWithMethod() {
        let method = MethodGenerationIntention(isStatic: false,
                                               name: "method",
                                               returnType: .int,
                                               parameters: [])
        method.signature.isStatic = true
        
        let sut = StaticModifiersDecorator()
        
        assert(decorator: sut,
               element: .intention(method),
               producesModifiers: ["static"])
    }
    
    func testStaticModifiersDecoratorWithProperty() {
        let property = PropertyGenerationIntention(name: "prop", type: .int) { builder in
            builder.setIsStatic(true)
        }
        
        let sut = StaticModifiersDecorator()
        
        assert(decorator: sut,
               element: .intention(property),
               producesModifiers: ["static"])
    }
    
    func testStaticModifiersDecoratorWithGlobalVariable() {
        let globalVar = GlobalVariableGenerationIntention(name: "type", type: .int)
        
        let sut = StaticModifiersDecorator()
        
        assert(decorator: sut, element: .intention(globalVar), producesModifiers: [])
    }
    
    func testAccessLevelModifiersDecorator() {
        let makeIntention: (AccessLevel) -> IntentionProtocol = {
            let intent = GlobalVariableGenerationIntention(name: "v", type: .int)
            intent.accessLevel = $0
            return intent
        }
        
        let sut = AccessLevelModifiersDecorator()
        
        assert(decorator: sut,
               element: .intention(makeIntention(.private)),
               producesModifiers: ["private"])
        
        assert(decorator: sut,
               element: .intention(makeIntention(.fileprivate)),
               producesModifiers: ["fileprivate"])
        
        assert(decorator: sut,
               element: .intention(makeIntention(.internal)),
               producesModifiers: [])
        
        assert(decorator: sut,
               element: .intention(makeIntention(.open)),
               producesModifiers: ["open"])
    }
    
    func testPropertySetterAccessModifiersDecorator() {
        let makeProperty: (AccessLevel?) -> IntentionProtocol = { accessLevel in
            PropertyGenerationIntention(name: "name", type: .int) { builder in
                builder.setSetterAccessLevel(accessLevel)
                builder.setAccessLevel(.open)
            }
        }
        
        let sut = PropertySetterAccessModifiersDecorator()
        
        assert(decorator: sut,
               element: .intention(makeProperty(.open)),
               producesModifiers: [])
        
        assert(decorator: sut,
               element: .intention(makeProperty(.public)),
               producesModifiers: ["public(set)"])
        
        assert(decorator: sut,
               element: .intention(makeProperty(.internal)),
               producesModifiers: ["internal(set)"])
        
        assert(decorator: sut,
               element: .intention(makeProperty(.fileprivate)),
               producesModifiers: ["fileprivate(set)"])
        
        assert(decorator: sut,
               element: .intention(makeProperty(.private)),
               producesModifiers: ["private(set)"])
    }
    
    func testOwnershipModifierDecoratorWithIntention() {
        let makeIntention: (Ownership) -> IntentionProtocol = { ownership in
            PropertyGenerationIntention(name: "name", type: .int) { builder in
                builder.setOwnership(ownership)
            }
        }
        
        let sut = OwnershipModifiersDecorator()
        
        assert(decorator: sut,
               element: .intention(makeIntention(.strong)),
               producesModifiers: [])
        
        assert(decorator: sut,
               element: .intention(makeIntention(.weak)),
               producesModifiers: ["weak"])
        
        assert(decorator: sut,
               element: .intention(makeIntention(.unownedSafe)),
               producesModifiers: ["unowned(safe)"])
        
        assert(decorator: sut,
               element: .intention(makeIntention(.unownedUnsafe)),
               producesModifiers: ["unowned(unsafe)"])
    }
    
    func testOwnershipModifierDecoratorWithVarDecl() {
        let makeVarDecl: (Ownership) -> StatementVariableDeclaration = { ownership in
            StatementVariableDeclaration(identifier: "v", type: .int, ownership: ownership)
        }
        
        let sut = OwnershipModifiersDecorator()
        
        assert(decorator: sut,
               element: .variableDecl(makeVarDecl(.strong)),
               producesModifiers: [])
        
        assert(decorator: sut,
               element: .variableDecl(makeVarDecl(.weak)),
               producesModifiers: ["weak"])
        
        assert(decorator: sut,
               element: .variableDecl(makeVarDecl(.unownedSafe)),
               producesModifiers: ["unowned(safe)"])
        
        assert(decorator: sut,
               element: .variableDecl(makeVarDecl(.unownedUnsafe)),
               producesModifiers: ["unowned(unsafe)"])
    }
    
    func testOverrideModifierDecorator() {
        let overriden = MethodGenerationIntention(name: "name") { builder in
            builder.setIsOverride(true)
        }
        let nonOverriden = MethodGenerationIntention(name: "name") { builder in
            builder.setIsOverride(false)
        }
        
        let sut = OverrideModifiersDecorator()
        
        assert(decorator: sut,
               element: .intention(overriden),
               producesModifiers: ["override"])
        
        assert(decorator: sut, element: .intention(nonOverriden), producesModifiers: [])
    }
    
    func testConvenienceInitModifierDecorator() {
        let _convenience = InitGenerationIntention { builder in
            builder.setIsConvenience(true)
        }
        let nonConvenience = InitGenerationIntention { builder in
            builder.setIsConvenience(false)
        }
        
        let sut = ConvenienceInitModifiersDecorator()
        
        assert(decorator: sut,
               element: .intention(_convenience),
               producesModifiers: ["convenience"])
        
        assert(decorator: sut, element: .intention(nonConvenience), producesModifiers: [])
    }
    
    func testProtocolOptionalModifierDecorator() {
        let prot = ProtocolGenerationIntention(typeName: "Prot")
        
        withExtendedLifetime(prot) {
            let optionalProp = ProtocolPropertyGenerationIntention(name: "name", type: .int, attributes: [])
            optionalProp.isOptional = true
            optionalProp.type = prot
            let nonOptionalProp = ProtocolPropertyGenerationIntention(name: "name", type: .int, attributes: [])
            nonOptionalProp.isOptional = false
            nonOptionalProp.type = prot
            let optionalMethod = ProtocolMethodGenerationIntention(name: "name", builder: { _ in })
            optionalMethod.isOptional = true
            optionalMethod.type = prot
            let nonOptionalMethod = ProtocolMethodGenerationIntention(name: "name", builder: { _ in })
            nonOptionalMethod.isOptional = false
            nonOptionalMethod.type = prot
            
            let sut = ProtocolOptionalModifiersDecorator()
            
            assert(decorator: sut,
                   element: .intention(optionalProp),
                   producesModifiers: ["optional"])
            
            assert(decorator: sut,
                   element: .intention(optionalMethod),
                   producesModifiers: ["optional"])
            
            assert(decorator: sut, element: .intention(nonOptionalProp), producesModifiers: [])
            
            assert(decorator: sut, element: .intention(nonOptionalMethod), producesModifiers: [])
        }
    }
}

extension ModifiersSyntaxDecoratorsTests {
    func assert(decorator: ModifiersSyntaxDecorator,
                element: DecoratableElement,
                producesModifiers expected: [String],
                line: Int = #line) {
        
        let producer = SwiftSyntaxProducer()
        let modifiers = decorator.modifiers(for: element)
        
        let modifierStrings = modifiers
            .map {
                $0(producer)
            }.map {
                $0.description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
        
        if expected != modifierStrings {
            recordFailure(
                withDescription: """
                Expected to produce modifiers \(expected), but produced \(modifierStrings)
                """,
                inFile: #file,
                atLine: line,
                expected: true)
        }
    }
}
