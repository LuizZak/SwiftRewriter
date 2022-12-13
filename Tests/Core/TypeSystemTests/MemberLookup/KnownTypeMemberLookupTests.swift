import XCTest
import KnownType
import TestCommons

@testable import TypeSystem

class KnownTypeMemberLookupTests: XCTestCase {
    private var typeSystem: TypeSystem!

    override func setUp() {
        typeSystem = TypeSystem()
    }

    func testMember() {
        let type = KnownTypeBuilder(typeName: "A")
            .addingAttribute(.dynamicMemberLookup)
            .property(named: "property", type: .double)
            .build()
        
        let sut = makeSut(type: type)

        Asserter(object: sut.member(named: "property", static: false)).inClosureUnconditional { member in
            member.assertNotNil()?
                .assert(isOfType: KnownProperty.self)
        }
        Asserter(object: sut.member(named: "nonExistingProperty", static: false)).inClosureUnconditional { member in
            member.assertNil()
        }
    }

    func testMember_dynamicMemberLookup() {
        let type = KnownTypeBuilder(typeName: "A")
            .addingAttribute(.dynamicMemberLookup)
            .property(named: "property", type: .double)
            .subscription(
                parameters: [
                    .init(label: "dynamicMember", name: "member", type: .string)
                ],
                returnType: .int
            )
            .build()
        
        let sut = makeSut(type: type)

        Asserter(object: sut.member(named: "property", static: false)).inClosureUnconditional { member in
            member.assertNotNil()?
                .assert(isOfType: KnownProperty.self)
        }
        Asserter(object: sut.member(named: "nonExistingProperty", static: false)).inClosureUnconditional { member in
            member.assertNotNil()?
                .assert(isOfType: KnownSubscript.self)
        }
    }

    // MARK: - Test internals

    private func makeSut(type: KnownType) -> KnownTypeMemberLookup {
        return KnownTypeMemberLookup(
            type: type,
            context: .init(
                typeSystem: typeSystem,
                memberSearchCache: MemberSearchCache(),
                visitedTypes: []
            )
        )
    }
}
