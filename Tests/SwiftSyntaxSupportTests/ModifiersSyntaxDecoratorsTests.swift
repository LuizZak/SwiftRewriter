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
                   producesModifier: "mutating")
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
            
            assert(decorator: sut, element: .intention(method), producesModifier: nil)
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
            
            assert(decorator: sut, element: .intention(method), producesModifier: nil)
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
               producesModifier: "static")
    }
    
    func testStaticModifiersDecoratorWithProperty() {
        let property = PropertyGenerationIntention(name: "prop", type: .int) { builder in
            builder.setIsStatic(true)
        }
        
        let sut = StaticModifiersDecorator()
        
        assert(decorator: sut,
               element: .intention(property),
               producesModifier: "static")
    }
    
    func testStaticModifiersDecoratorWithGlobalVariable() {
        let globalVar = GlobalVariableGenerationIntention(name: "type", type: .int)
        
        let sut = StaticModifiersDecorator()
        
        assert(decorator: sut, element: .intention(globalVar), producesModifier: nil)
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
               producesModifier: "private")
        
        assert(decorator: sut,
               element: .intention(makeIntention(.fileprivate)),
               producesModifier: "fileprivate")
        
        assert(decorator: sut,
               element: .intention(makeIntention(.internal)),
               producesModifier: nil)
        
        assert(decorator: sut,
               element: .intention(makeIntention(.open)),
               producesModifier: "open")
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
               producesModifier: nil)
        
        assert(decorator: sut,
               element: .intention(makeProperty(.public)),
               producesModifier: nil)
        
        assert(decorator: sut,
               element: .intention(makeProperty(.internal)),
               producesModifier: "internal(set)")
        
        assert(decorator: sut,
               element: .intention(makeProperty(.fileprivate)),
               producesModifier: "fileprivate(set)")
        
        assert(decorator: sut,
               element: .intention(makeProperty(.private)),
               producesModifier: "private(set)")
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
               producesModifier: nil)
        
        assert(decorator: sut,
               element: .intention(makeIntention(.weak)),
               producesModifier: "weak")
        
        assert(decorator: sut,
               element: .intention(makeIntention(.unownedSafe)),
               producesModifier: "unowned(safe)")
        
        assert(decorator: sut,
               element: .intention(makeIntention(.unownedUnsafe)),
               producesModifier: "unowned(unsafe)")
    }
    
    func testOwnershipModifierDecoratorWithVarDecl() {
        let makeVarDecl: (Ownership) -> StatementVariableDeclaration = { ownership in
            StatementVariableDeclaration(identifier: "v", type: .int, ownership: ownership)
        }
        
        let sut = OwnershipModifiersDecorator()
        
        assert(decorator: sut,
               element: .variableDecl(makeVarDecl(.strong)),
               producesModifier: nil)
        
        assert(decorator: sut,
               element: .variableDecl(makeVarDecl(.weak)),
               producesModifier: "weak")
        
        assert(decorator: sut,
               element: .variableDecl(makeVarDecl(.unownedSafe)),
               producesModifier: "unowned(safe)")
        
        assert(decorator: sut,
               element: .variableDecl(makeVarDecl(.unownedUnsafe)),
               producesModifier: "unowned(unsafe)")
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
               producesModifier: "override")
        
        assert(decorator: sut, element: .intention(nonOverriden), producesModifier: nil)
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
               producesModifier: "convenience")
        
        assert(decorator: sut, element: .intention(nonConvenience), producesModifier: nil)
    }
    
    func testProtocolOptionalModifierDecorator() {
        let prot = ProtocolGenerationIntention(typeName: "Prot")
        
        withExtendedLifetime(prot) {
            let optionalProp = ProtocolPropertyGenerationIntention(name: "name", type: .int, objcAttributes: [])
            optionalProp.isOptional = true
            optionalProp.type = prot
            let nonOptionalProp = ProtocolPropertyGenerationIntention(name: "name", type: .int, objcAttributes: [])
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
                   producesModifier: "optional")
            
            assert(decorator: sut,
                   element: .intention(optionalMethod),
                   producesModifier: "optional")
            
            assert(decorator: sut, element: .intention(nonOptionalProp), producesModifier: nil)
            
            assert(decorator: sut, element: .intention(nonOptionalMethod), producesModifier: nil)
        }
    }
}

extension ModifiersSyntaxDecoratorsTests {
    func assert(decorator: ModifiersSyntaxDecorator,
                element: DecoratableElement,
                producesModifier expected: String?,
                line: Int = #line) {
        
        let producer = SwiftSyntaxProducer()
        let modifiers = decorator.modifier(for: element)
        
        let modifierString = modifiers
            .map {
                $0(producer)
            }.map {
                $0.description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            }
        
        if expected != modifierString {
            recordFailure(
                withDescription: """
                Expected to produce modifier \(expected ?? "<nil>"), but produced \(modifierString ?? "<nil>")
                """,
                inFile: #file,
                atLine: line,
                expected: true)
        }
    }
}
