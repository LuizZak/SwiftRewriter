import SwiftAST
import KnownType

class TypeMemberLookupContext {
    let typeSystem: TypeSystem
    let memberSearchCache: MemberSearchCache
    var visitedTypes: Set<String>

    init(
        typeSystem: TypeSystem,
        memberSearchCache: MemberSearchCache,
        visitedTypes: Set<String>
    ) {
        self.typeSystem = typeSystem
        self.memberSearchCache = memberSearchCache
        self.visitedTypes = visitedTypes
    }

    func makeKnownTypeLookup(_ type: KnownType) -> KnownTypeMemberLookup {
        KnownTypeMemberLookup(
            type: type,
            context: self
        )
    }

    func makeSwiftTypeLookup(_ swiftType: SwiftType) -> SwiftTypeMemberLookup {
        SwiftTypeMemberLookup(
            type: swiftType,
            context: self
        )
    }
}
