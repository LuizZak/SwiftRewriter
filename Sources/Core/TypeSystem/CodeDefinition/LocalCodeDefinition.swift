import Intentions
import SwiftAST

public class LocalCodeDefinition: CodeDefinition {
    public var location: DefinitionLocation

    convenience init(
        variableNamed name: String,
        type: SwiftType,
        ownership: Ownership = .strong,
        location: DefinitionLocation
    ) {

        self.init(
            variableNamed: name,
            storage: ValueStorage(
                type: type,
                ownership: ownership,
                isConstant: false
            ),
            location: location
        )
    }

    convenience init(
        constantNamed name: String,
        type: SwiftType,
        ownership: Ownership = .strong,
        location: DefinitionLocation
    ) {

        self.init(
            variableNamed: name,
            storage: ValueStorage(
                type: type,
                ownership: ownership,
                isConstant: true
            ),
            location: location
        )
    }

    init(variableNamed name: String, storage: ValueStorage, location: DefinitionLocation) {
        self.location = location

        super.init(variableNamed: name, storage: storage)
    }

    init(functionSignature: FunctionSignature, location: DefinitionLocation) {
        self.location = location

        super.init(functionSignature: functionSignature)
    }

    public override func isEqual(to other: CodeDefinition) -> Bool {
        switch other {
        case let other as LocalCodeDefinition:
            return isEqual(to: other)
        default:
            return super.isEqual(to: other)
        }
    }

    public func isEqual(to other: LocalCodeDefinition) -> Bool {
        (self.kind == other.kind && self.location == other.location)
    }

    public enum DefinitionLocation: Hashable {
        case instanceSelf
        case staticSelf
        case setterValue
        case parameter(index: Int)
        case variableDeclaration(StatementVariableDeclaration)
        case forLoop(ForStatement, PatternLocation)
        case ifClause(IfStatement, clauseIndex: Int, PatternLocation)
        case whileClause(WhileStatement, clauseIndex: Int, PatternLocation)
        case conditionalClause(ConditionalClauseElement, PatternLocation)
        case localFunction(LocalFunctionStatement)
        case catchBlock(CatchBlock, PatternLocation?)

        public var canModify: Bool {
            switch self {
            case
                .instanceSelf,
                .staticSelf,
                .setterValue,
                .forLoop,
                .ifClause,
                .whileClause,
                .conditionalClause,
                .localFunction,
                .parameter,
                .catchBlock:
                return false

            case .variableDeclaration:
                return true
            }
        }

        public func modifyType(_ newType: SwiftType) {
            switch self {
            case
                .instanceSelf,
                .staticSelf,
                .setterValue,
                .forLoop,
                .ifClause,
                .whileClause,
                .conditionalClause,
                .localFunction,
                .parameter,
                .catchBlock:
                break

            case .variableDeclaration(let decl):
                decl.type = newType
            }
        }

        public func hash(into hasher: inout Hasher) {
            switch self {
            case .instanceSelf:
                hasher.combine(1)

            case .staticSelf:
                hasher.combine(2)

            case .setterValue:
                hasher.combine(3)

            case .parameter(let index):
                hasher.combine(4)
                hasher.combine(index)

            case let .variableDeclaration(decl):
                hasher.combine(5)
                hasher.combine(ObjectIdentifier(decl))

            case let .forLoop(stmt, loc):
                hasher.combine(6)
                hasher.combine(ObjectIdentifier(stmt))
                hasher.combine(loc)

            case let .ifClause(stmt, index, loc):
                hasher.combine(7)
                hasher.combine(ObjectIdentifier(stmt))
                hasher.combine(index)
                hasher.combine(loc)

            case let .whileClause(stmt, index, loc):
                hasher.combine(8)
                hasher.combine(ObjectIdentifier(stmt))
                hasher.combine(index)
                hasher.combine(loc)

            case let .conditionalClause(clause, loc):
                hasher.combine(9)
                hasher.combine(ObjectIdentifier(clause))
                hasher.combine(loc)

            case let .localFunction(stmt):
                hasher.combine(10)
                hasher.combine(ObjectIdentifier(stmt))

            case .catchBlock(let catchBlock, let loc):
                hasher.combine(11)
                hasher.combine(ObjectIdentifier(catchBlock.body))
                hasher.combine(loc)
            }
        }
    }
}

extension LocalCodeDefinition: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(location)
    }
}

public extension CodeDefinition {
    /// Creates a set of code definitions that correspond to the parameters of a
    /// given function signature
    static func forParameters(inSignature signature: FunctionSignature) -> [LocalCodeDefinition] {
        forParameters(signature.parameters)
    }

    /// Creates a set of code definitions that correspond to the given set of
    /// parameters
    static func forParameters(_ parameters: [ParameterSignature]) -> [LocalCodeDefinition] {
        parameters.enumerated().map { (i, param) in
            let type: SwiftType
            if param.isVariadic {
                type = .array(param.type)
            } else {
                type = param.type
            }

            return LocalCodeDefinition(
                constantNamed: param.name,
                type: type,
                location: .parameter(index: i)
            )
        }
    }

    /// Creates a set of code definitions that correspond to the given set of
    /// block parameters
    static func forParameters(_ parameters: [BlockParameter]) -> [LocalCodeDefinition] {
        parameters.enumerated().map { (i, param) in
            LocalCodeDefinition(
                constantNamed: param.name,
                type: param.type,
                location: .parameter(index: i)
            )
        }
    }

    /// Creates a code definition that matches the instance or static type of
    /// `type`.
    /// Used for creating self intrinsics for member bodies.
    static func forSelf(type: TypeGenerationIntention, isStatic: Bool) -> LocalCodeDefinition {
        forSelf(type: type.asSwiftType, isStatic: isStatic)
    }

    /// Creates a code definition that matches the instance or static type of
    /// `type`.
    /// Used for creating self intrinsics for member bodies.
    static func forSelf(type: SwiftType, isStatic: Bool) -> LocalCodeDefinition {
        LocalCodeDefinition(
            constantNamed: "self",
            type: isStatic ? .metatype(for: type) : type,
            location: isStatic ? .staticSelf : .instanceSelf
        )
    }

    /// Creates a code definition that matches the instance or static type of
    /// `super`.
    /// Used for creating self intrinsics for member bodies.
    static func forSuper(type: TypeGenerationIntention, isStatic: Bool) -> LocalCodeDefinition {
        forSuper(type: type.asSwiftType, isStatic: isStatic)
    }

    /// Creates a code definition that matches the instance or static type of
    /// `super`.
    /// Used for creating self intrinsics for member bodies.
    static func forSuper(type: SwiftType, isStatic: Bool) -> LocalCodeDefinition {
        LocalCodeDefinition(
            constantNamed: "super",
            type: isStatic ? .metatype(for: type) : type,
            location: isStatic ? .staticSelf : .instanceSelf
        )
    }

    /// Creates a code definition for the setter of a setter method body.
    static func forSetterValue(named name: String, type: SwiftType) -> LocalCodeDefinition {
        LocalCodeDefinition(
            constantNamed: name,
            type: type,
            location: .setterValue
        )
    }

    /// Creates a code definition for a local identifier
    static func forLocalIdentifier(
        _ identifier: String,
        type: SwiftType,
        ownership: Ownership = .strong,
        isConstant: Bool,
        location: LocalCodeDefinition.DefinitionLocation
    ) -> LocalCodeDefinition {

        if isConstant {
            return LocalCodeDefinition(
                constantNamed: identifier,
                type: type,
                ownership: ownership,
                location: location
            )
        }

        return LocalCodeDefinition(
            variableNamed: identifier,
            type: type,
            ownership: ownership,
            location: location
        )
    }

    /// Creates a code definition for the captured error value of a do statement's
    /// catch block.
    static func forCatchBlockPattern(
        _ catchBlock: CatchBlock
    ) -> LocalCodeDefinition {

        if let pattern = catchBlock.pattern {
            switch pattern.simplified {
            case .identifier(let name):
                return LocalCodeDefinition(
                    constantNamed: name,
                    type: .swiftError,
                    location: .catchBlock(catchBlock, .`self`)
                )
            // TODO: Support mode pattern binding types
            default:
                break
            }
        }

        return LocalCodeDefinition(
            constantNamed: "error",
            type: .swiftError,
            location: .catchBlock(catchBlock, nil)
        )
    }

    static func forVarDeclStatement(_ stmt: VariableDeclarationsStatement) -> [LocalCodeDefinition] {
        stmt.decl.enumerated().map { (i, decl) in
            forVarDeclElement(decl)
        }
    }

    static func forVarDeclElement(
        _ decl: StatementVariableDeclaration
    ) -> LocalCodeDefinition {

        CodeDefinition.forLocalIdentifier(
            decl.identifier,
            type: decl.type,
            ownership: decl.ownership,
            isConstant: decl.isConstant,
            location: .variableDeclaration(decl)
        )
    }

    static func forLocalFunctionStatement(_ stmt: LocalFunctionStatement) -> LocalCodeDefinition {
        LocalCodeDefinition(
            functionSignature: stmt.function.signature,
            location: .localFunction(stmt)
        )
    }
}
