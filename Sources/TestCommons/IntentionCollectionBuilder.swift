import Utils
import GrammarModels
import SwiftAST
import KnownType
import Intentions
import TypeSystem

/// An empty initializer used as default argument of initializer closure parameters
/// for `IntentionCollectionBuilder` and related classes.
///
/// Is effectively a no-op.
@inlinable
public func emptyInit<T>(_: T) {
    
}

public class IntentionCollectionBuilder {
    var intentions = IntentionCollection()
    
    public init() {
        
    }
    
    @discardableResult
    public func createFileWithClass(
        named name: String,
        initializer: (TypeBuilder<ClassGenerationIntention>) -> Void = emptyInit) -> IntentionCollectionBuilder {
        
        createFile(named: "\(name).swift") { builder in
            builder.createClass(withName: name, initializer: initializer)
        }
        
        return self
    }
    
    @discardableResult
    public func createFile(named name: String,
                           initializer: (FileIntentionBuilder) -> Void = emptyInit) -> IntentionCollectionBuilder {
        
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
    
    public static func makeFileIntention(fileName: String,
                                         _ builderBlock: (FileIntentionBuilder) -> Void) -> FileGenerationIntention {
        
        let builder = FileIntentionBuilder(fileNamed: fileName)
        
        builderBlock(builder)
        
        return builder.build()
    }
    
    public init(fileNamed name: String) {
        intention = FileGenerationIntention(sourcePath: name, targetPath: name)
    }
    
    @discardableResult
    public func createGlobalVariable(withName name: String,
                                     type: SwiftType,
                                     ownership: Ownership = .strong,
                                     isConstant: Bool = false,
                                     accessLevel: AccessLevel = .internal,
                                     initialExpression: Expression? = nil) -> FileIntentionBuilder {
        let storage =
            ValueStorage(type: type, ownership: ownership, isConstant: isConstant)
        
        return createGlobalVariable(withName: name,
                                    storage: storage,
                                    accessLevel: accessLevel,
                                    initialExpression: initialExpression)
    }
    
    @discardableResult
    public func createGlobalVariable(withName name: String,
                                     storage: ValueStorage,
                                     accessLevel: AccessLevel = .internal,
                                     initialExpression: Expression? = nil) -> FileIntentionBuilder {
        let varIntention =
            GlobalVariableGenerationIntention(name: name,
                                              storage: storage,
                                              accessLevel: accessLevel)
        
        varIntention.inNonnullContext = inNonnullContext
        
        if let initialExpression = initialExpression {
            varIntention.initialValueExpr =
                GlobalVariableInitialValueIntention(expression: initialExpression,
                                                    source: nil)
        }
        
        intention.addGlobalVariable(varIntention)
        
        return self
    }
    
    @discardableResult
    public func createGlobalFunction(withName name: String,
                                     returnType: SwiftType = .void,
                                     parameters: [ParameterSignature] = [],
                                     body: CompoundStatement? = nil) -> FileIntentionBuilder {
        let signature =
            FunctionSignature(name: name,
                              parameters: parameters,
                              returnType: returnType,
                              isStatic: false)
        
        return createGlobalFunction(withSignature: signature, body: body)
    }
    
    @discardableResult
    public func createGlobalFunction(withSignature signature: FunctionSignature,
                                     body: CompoundStatement? = nil) -> FileIntentionBuilder {
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
    public func createGlobalFunction(withName name: String,
                                     _ initialization: (FunctionBuilder<GlobalFunctionGenerationIntention>) -> Void) -> FileIntentionBuilder {
        
        var funcIntent = GlobalFunctionGenerationIntention(signature: FunctionSignature(name: name))
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
        initializer: (TypeBuilder<ClassGenerationIntention>) -> Void = emptyInit) -> FileIntentionBuilder {
        
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
    public func createTypealias(withName name: String,
                                swiftType: SwiftType,
                                type: ObjcType) -> FileIntentionBuilder {
        
        let intent = TypealiasIntention(originalObjcType: type,
                                        fromType: swiftType,
                                        named: name)
        
        intent.inNonnullContext = inNonnullContext
        
        intention.addTypealias(intent)
        
        return self
    }
    
    @discardableResult
    public func createExtension(
        forClassNamed name: String,
        categoryName: String? = nil,
        initializer: (TypeBuilder<ClassExtensionGenerationIntention>) -> Void = emptyInit) -> FileIntentionBuilder {
        
        let classIntention = ClassExtensionGenerationIntention(typeName: name)
        classIntention.categoryName = categoryName
        classIntention.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: classIntention, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createProtocol(
        withName name: String,
        initializer: (TypeBuilder<ProtocolGenerationIntention>) -> Void = emptyInit) -> FileIntentionBuilder {
        
        let prot = ProtocolGenerationIntention(typeName: name)
        prot.inNonnullContext = inNonnullContext
        
        innerBuildTypeWithClosure(type: prot, initializer: initializer)
        
        return self
    }
    
    @discardableResult
    public func createEnum(withName name: String, rawValue: SwiftType,
                           initializer: (EnumTypeBuilder) -> Void = emptyInit) -> FileIntentionBuilder {
        
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
        initializer: (TypeBuilder<StructGenerationIntention>) -> Void = emptyInit) -> FileIntentionBuilder {
        
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
    public func addPreprocessorDirective(_ directive: String, line: Int) -> FileIntentionBuilder {
        let location = SourceLocation(line: line, column: 1, utf8Offset: 0)
        let lineRanges = directive.lineRanges()
        
        let columnsAtLastLine = lineRanges.count == 1
            ? directive.count
            : directive.distance(from: lineRanges.last!.lowerBound, to: lineRanges.last!.upperBound)
        
        let length = SourceLength(newlines: lineRanges.count - line,
                                  columnsAtLastLine: columnsAtLastLine,
                                  utf8Length: directive.count)
        
        let directive = ObjcPreprocessorDirective(string: directive,
                                                  range: 0..<directive.count,
                                                  location: location,
                                                  length: length)
        
        intention.preprocessorDirectives.append(directive)
        
        return self
    }
    
    private func innerBuildTypeWithClosure<T>(
        type: T,
        initializer: (TypeBuilder<T>) -> Void) where T: TypeGenerationIntention {
        
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
    public func addComment(_ comment: String) -> FunctionBuilder {
        target.precedingComments.append(comment)
        return self
    }
    
    @discardableResult
    public func addComments(_ comments: [String]) -> FunctionBuilder {
        target.precedingComments.append(contentsOf: comments)
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
        targetEnum.precedingComments.append(comment)
        return self
    }
    
    @discardableResult
    public func addComments(_ comments: [String]) -> EnumTypeBuilder {
        targetEnum.precedingComments.append(contentsOf: comments)
        return self
    }
    
    public func build() -> EnumGenerationIntention {
        targetEnum
    }
}
