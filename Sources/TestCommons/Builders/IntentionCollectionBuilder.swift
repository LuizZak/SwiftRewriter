import Utils
import ObjcGrammarModels
import SwiftAST
import KnownType
import Intentions
import TypeSystem
import GrammarModelBase
import ObjectiveCFrontend
import MiniLexer

/// An empty initializer used as default argument of initializer closure parameters
/// for `IntentionCollectionBuilder` and related classes.
///
/// Is effectively a no-op.
@inlinable
public func emptyInit<T>(_: T) {
    
}

private func _isValidTypeIdentifier(_ str: String) -> Bool {
    do {
        let lexer = Lexer(input: str)
        try lexer.advance(validatingCurrent: Lexer.isLetter)
        lexer.advance(while: Lexer.isAlphanumeric)
        lexer.skipWhitespace()

        if !lexer.isEof() {
            return false
        }

        return true
    } catch {
        return false
    }
}

public class IntentionCollectionBuilder {
    var intentions = IntentionCollection()
    
    public init() {
        
    }
    
    @discardableResult
    public func createFileWithClass(
        named name: String,
        file: StaticString = #file,
        line: UInt = #line,
        initializer: (TypeBuilder<ClassGenerationIntention>) -> Void = emptyInit
    ) -> IntentionCollectionBuilder {

        // Sanitize type name and issue a warning for invalid type names
        if !_isValidTypeIdentifier(name) {
            print(#"\#(file):\#(line): warning: ("\#(name)") is not a valid Swift class name identifier!"#)
        }
        
        createFile(named: "\(name).swift") { builder in
            builder.createClass(withName: name, initializer: initializer)
        }
        
        return self
    }
    
    @discardableResult
    public func createFile(
        named name: String,
        initializer: (FileIntentionBuilder) -> Void = emptyInit
    ) -> IntentionCollectionBuilder {
        
        let builder = FileIntentionBuilder(fileNamed: name)
        
        initializer(builder)
        
        let file = builder.build()
        
        intentions.addIntention(file)
        
        return self
    }
    
    public func build(typeChecked: Bool = false) -> IntentionCollection {
        if typeChecked {
            let system = IntentionCollectionTypeSystem(intentions: intentions)
            
            let invoker =
                DefaultTypeResolverInvoker(
                    globals: ArrayDefinitionsSource(),
                    typeSystem: system,
                    numThreads: 8
                )
            
            invoker.resolveAllExpressionTypes(in: intentions, force: true)
        }
        
        return intentions
    }
}

public class FileIntentionBuilder {
    var inNonnullContext = false
    var intention: FileGenerationIntention
    
    public static func makeFileIntention(
        fileName: String,
        _ builderBlock: (FileIntentionBuilder) -> Void
    ) -> FileGenerationIntention {
        
        let builder = FileIntentionBuilder(fileNamed: fileName)
        
        builderBlock(builder)
        
        return builder.build()
    }
    
    public init(fileNamed name: String) {
        intention = FileGenerationIntention(sourcePath: name, targetPath: name)
    }

    public func addMetadata(forKey key: String, value: Any, type: String) {
        intention.metadata.updateValue(value, type: type, forKey: key)
    }
    
    @discardableResult
    public func createGlobalVariable(
        withName name: String,
        type: SwiftType,
        ownership: Ownership = .strong,
        isConstant: Bool = false,
        accessLevel: AccessLevel = .internal,
        initialExpression: Expression? = nil
    ) -> FileIntentionBuilder {

        let storage =
            ValueStorage(type: type, ownership: ownership, isConstant: isConstant)
        
        return createGlobalVariable(
            withName: name,
            storage: storage,
            accessLevel: accessLevel,
            initialExpression: initialExpression
        )
    }
    
    @discardableResult
    public func createGlobalVariable(
        withName name: String,
        storage: ValueStorage,
        accessLevel: AccessLevel = .internal,
        initialExpression: Expression? = nil
    ) -> FileIntentionBuilder {

        let varIntention =
            GlobalVariableGenerationIntention(
                name: name,
                storage: storage,
                accessLevel: accessLevel
            )
        
        varIntention.inNonnullContext = inNonnullContext
        
        if let initialExpression = initialExpression {
            varIntention.initialValueIntention =
                GlobalVariableInitialValueIntention(
                    expression: initialExpression,
                    source: nil
                )
        }
        
        intention.addGlobalVariable(varIntention)
        
        return self
    }
    
    @discardableResult
    public func createGlobalFunction(
        withName name: String,
        returnType: SwiftType = .void,
        parameters: [ParameterSignature] = [],
        body: CompoundStatement? = nil
    ) -> FileIntentionBuilder {

        let signature =
            FunctionSignature(
                name: name,
                parameters: parameters,
                returnType: returnType,
                isStatic: false
            )
        
        return createGlobalFunction(withSignature: signature, body: body)
    }
    
    @discardableResult
    public func createGlobalFunction(
        withSignature signature: FunctionSignature,
        body: CompoundStatement? = nil
    ) -> FileIntentionBuilder {

        let funcIntent =
            GlobalFunctionGenerationIntention(signature: signature)
        funcIntent.inNonnullContext = inNonnullContext
        
        if let body = body {
            funcIntent.functionBody = FunctionBodyIntention(body: body)
        }
        
        intention.addGlobalFunction(funcIntent)
        
        return self
    }
    
    @discardableResult
    public func createGlobalFunction(
        withName name: String,
        _ initialization: (FunctionBuilder<GlobalFunctionGenerationIntention>) -> Void
    ) -> FileIntentionBuilder {
        
        var funcIntent = GlobalFunctionGenerationIntention(
            signature: FunctionSignature(name: name),
            functionBody: FunctionBodyIntention(body: [])
        )
        
        funcIntent.inNonnullContext = inNonnullContext
        
        let builder = FunctionBuilder<GlobalFunctionGenerationIntention>(target: funcIntent)
        initialization(builder)
        
        funcIntent = builder.build()
        
        intention.addGlobalFunction(funcIntent)
        
        return self
    }
    
    @discardableResult
    public func createClass(
        withName name: String,
        initializer: (TypeBuilder<ClassGenerationIntention>) -> Void = emptyInit
    ) -> FileIntentionBuilder {
        
        let classIntention = ClassGenerationIntention(typeName: name)
        classIntention.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: classIntention, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createTypealias(withName name: String, type: ObjcType) -> FileIntentionBuilder {
        let swiftType = DefaultTypeMapper().swiftType(forObjcType: type, context: .empty)
        
        return self.createTypealias(withName: name, swiftType: swiftType, type: type)
    }
    
    @discardableResult
    public func createTypealias(
        withName name: String,
        swiftType: SwiftType,
        type: ObjcType
    ) -> FileIntentionBuilder {
        
        let intent = TypealiasIntention(
            originalObjcType: type,
            fromType: swiftType,
            named: name
        )
        
        intent.inNonnullContext = inNonnullContext
        
        intention.addTypealias(intent)
        
        return self
    }
    
    @discardableResult
    public func createExtension(
        forClassNamed name: String,
        categoryName: String? = nil,
        initializer: (TypeBuilder<ClassExtensionGenerationIntention>) -> Void = emptyInit
    ) -> FileIntentionBuilder {
        
        let classIntention = ClassExtensionGenerationIntention(typeName: name)
        classIntention.categoryName = categoryName
        classIntention.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: classIntention, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createProtocol(
        withName name: String,
        initializer: (TypeBuilder<ProtocolGenerationIntention>) -> Void = emptyInit
    ) -> FileIntentionBuilder {
        
        let prot = ProtocolGenerationIntention(typeName: name)
        prot.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: prot, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createEnum(
        withName name: String,
        rawValue: SwiftType,
        initializer: (EnumTypeBuilder) -> Void = emptyInit
    ) -> FileIntentionBuilder {
        
        let enumIntention = EnumGenerationIntention(typeName: name, rawValueType: rawValue)
        enumIntention.inNonnullContext = inNonnullContext
        let builder = EnumTypeBuilder(targetEnum: enumIntention)
        
        initializer(builder)
        
        intention.addType(builder.build())
        
        return self
    }
    
    @discardableResult
    public func createStruct(
        withName name: String,
        initializer: (TypeBuilder<StructGenerationIntention>) -> Void = emptyInit
    ) -> FileIntentionBuilder {
        
        let structIntention = StructGenerationIntention(typeName: name)
        structIntention.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: structIntention, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func beginNonnulContext() -> FileIntentionBuilder {
        inNonnullContext = true
        return self
    }
    
    @discardableResult
    public func endNonnullContext() -> FileIntentionBuilder {
        inNonnullContext = false
        return self
    }
    
    @discardableResult
    public func isPrimary(_ isPrimary: Bool) -> FileIntentionBuilder {
        intention.isPrimary = isPrimary
        return self
    }
    
    @discardableResult
    public func addImportDirective(moduleName: String) -> FileIntentionBuilder {
        intention.importDirectives.append(moduleName)
        
        return self
    }
    
    @discardableResult
    public func addHeaderComment(_ comment: String) -> FileIntentionBuilder {
        intention.headerComments.append(comment)

        return self
    }
    
    private func innerBuildTypeWithClosure<T>(
        type: T,
        initializer: (TypeBuilder<T>) -> Void
    ) where T: TypeGenerationIntention {
        
        let builder = TypeBuilder(targetType: type)
        initializer(builder)
        intention.addType(builder.build())
    }
    
    public func build() -> FileGenerationIntention {
        intention
    }
}

public class FunctionSignatureBuilder {
    var signature: FunctionSignature
    
    init(signature: FunctionSignature) {
        self.signature = signature
    }
    
    @discardableResult
    public func addParameter(name: String, type: SwiftType) -> FunctionSignatureBuilder {
        signature.parameters.append(
            ParameterSignature(label: name, name: name, type: type)
        )
        
        return self
    }
    
    @discardableResult
    public func setIsStatic(_ isStatic: Bool) -> FunctionSignatureBuilder {
        signature.isStatic = isStatic
        
        return self
    }
    
    @discardableResult
    public func setIsMutating(_ isMutating: Bool) -> FunctionSignatureBuilder {
        signature.isMutating = isMutating
        
        return self
    }
    
    @discardableResult
    public func setReturnType(_ type: SwiftType) -> FunctionSignatureBuilder {
        signature.returnType = type
        
        return self
    }
    
    func build() -> FunctionSignature {
        signature
    }
}

public class FunctionBuilder<T: FunctionIntention>: _FunctionBuilder {
    public var target: T
    
    init(target: T) {
        self.target = target
    }
    
    public func build() -> T {
        target
    }
}

extension FunctionBuilder where T: FromSourceIntention {
    @discardableResult
    public func addComment(_ comment: SwiftComment) -> FunctionBuilder {
        target.precedingComments.append(comment)
        return self
    }
    
    @discardableResult
    public func addComments(_ comments: [SwiftComment]) -> FunctionBuilder {
        target.precedingComments.append(
            contentsOf: comments
        )

        return self
    }
}

public class EnumTypeBuilder {
    var targetEnum: EnumGenerationIntention
    
    public init(targetEnum: EnumGenerationIntention) {
        self.targetEnum = targetEnum
    }
    
    @discardableResult
    public func createCase(name: String, expression: Expression? = nil) -> EnumTypeBuilder {
        let caseIntention = EnumCaseGenerationIntention(name: name, expression: expression)
        
        targetEnum.addCase(caseIntention)
        
        return self
    }
    
    @discardableResult
    public func addComment(_ comment: String) -> EnumTypeBuilder {
        targetEnum.precedingComments.append(.line(comment))
        return self
    }
    
    @discardableResult
    public func addComments(_ comments: [String]) -> EnumTypeBuilder {
        targetEnum.precedingComments.append(contentsOf: comments.map(SwiftComment.line(_:)))
        return self
    }
    
    public func build() -> EnumGenerationIntention {
        targetEnum
    }
}
