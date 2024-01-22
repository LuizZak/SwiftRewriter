import SwiftSyntax
import SwiftParser
import Intentions
import SwiftAST
import KnownType
import Observation

/// Provides `Intention` and `SwiftAST`-to-string conversion capabilities.
public class SwiftProducer {
    let settings: Settings
    weak var delegate: SwiftProducerDelegate?

    var indentationMode: IndentationMode = .spaces(4)
    
    /// Current indentation level.
    var indentation: Int = 0

    var pendingPrefix: [PendingPrefix] = []

    /// The string buffer that represents the final file.
    var buffer: String = ""

    public init(settings: Settings = .default, delegate: SwiftProducerDelegate? = nil) {
        self.settings = settings
        self.delegate = delegate
    }

    /// Returns `true` if the last character of the buffer is a line feed (\n).
    func isOnNewline() -> Bool {
        buffer.hasSuffix("\n")
    }

    /// Returns `true` if the last character of the buffer is a space or line
    /// feed (\n).
    /// Also returns `true` if the buffer is empty.
    func isOnSpaceSeparator() -> Bool {
        buffer.isEmpty || isOnNewline() || buffer.hasSuffix(" ")
    }

    /// Returns `true` if the last two characters of the buffer are line feeds
    /// (\n\n).
    func isOnDoubleNewline() -> Bool {
        buffer.hasSuffix("\n\n")
    }

    /// Returns the string form of the indentation to put on lines.
    func indentationString() -> String {
        String(repeating: indentationMode.asString, count: indentation)
    }

    /// Creates a new conditional emitter that is monitoring changes from this
    /// point in the buffer.
    func startConditionalEmitter() -> ConditionalEmitter {
        ConditionalEmitter(producer: self)
    }

    /// Empties the buffer and resets the indentation level back to zero.
    func resetState() {
        indentation = 0
        buffer = ""
    }

    /// Performs end-of-production changes to the buffer, like removing redundant
    /// line feeds from the end of the buffer.
    func finishBuffer() {
        while buffer.hasSuffix("\n") {
            buffer.removeLast()
        }
    }

    /// Increases current indentation level by one.
    func indent() {
        indentation += 1
    }

    /// Decreases current indentation level by one.
    func unindent() {
        indentation = max(0, indentation - 1)
    }

    /// Emits the given text into the buffer as-is.
    func emitRaw(_ text: String) {
        buffer += text
    }

    /// Emits the given text into the buffer, appropriately indenting text on new-line.
    func emit(_ text: String) {
        if !text.hasPrefix("\n") {
            ensureIndentation()
        }

        emitRaw(text)
    }

    /// Emits the given text and pushes a new line onto the buffer.
    func emitLine(_ text: String) {
        emit(text)
        emitNewline()
    }

    /// Emits a line feed (\n) into the buffer.
    func emitNewline() {
        emitRaw("\n")
    }

    /// Emits a space separator to separate the current stream of characters from
    /// an incoming stream in the buffer.
    func emitSpaceSeparator() {
        emitRaw(" ")
    }

    /// Emits a line comment in the buffer.
    /// The comment is automatically prefixed with '// ', and a line feed is also
    /// added to the end of the line.
    func emitComment(_ line: String) {
        emitLine("// \(line)")
    }

    /// Emits a block comment with the given contents. Automatically prefixes and
    /// suffixes the comment with the comment delimiters '/*' and '*/' and a line
    /// feed at the end.
    func emitCommentBlock(_ lines: String) {
        emitLine("/* \(lines) */")
    }

    /// Emits a doc comment line in the buffer.
    /// The comment is automatically prefixed with '/// ', and a line feed is also
    /// added to the end of the line.
    func emitDocComment(_ line: String) {
        emitLine("/// \(line)")
    }

    /// Emits a doc block comment with the given contents. Automatically prefixes
    /// and suffixes the comment with the comment delimiters '/**' and '*/' and
    /// a line feed at the end.
    func emitDocCommentBlock(_ lines: String) {
        emitLine("/** \(lines) */")
    }

    /// Emits a pending prefix entry to the buffer, with a line feed at the
    /// end.
    func emitPrefix(_ prefix: PendingPrefix) {
        switch prefix {
        case .docComment(let line):
            emitDocComment(line)
        case .lineComment(let line):
            emitComment(line)
        }
    }

    /// Emits all pending prefix lines, clearing them from the queue in the
    /// process.
    func emitPendingPrefix() {
        pendingPrefix.forEach(emitPrefix)
        pendingPrefix.removeAll()
    }

    /// Calls a block for emitting contents into the buffer, finishing with a line
    /// feed at the end.
    /// In case a line feed was inserted by the block itself, no extra line feed
    /// is inserted.
    func emitLineWith(_ block: () -> Void) {
        let bufferSizeBefore = buffer.count
        
        block()

        guard buffer.count > bufferSizeBefore else {
            emitNewline()
            return
        }

        if !isOnNewline() {
            emitNewline()
        }
    }

    /// Emits contents from a given sequence of items by passing them through a
    /// producer that may call other `emit-` functions, where this function
    /// automatically separates elements that appear in between with `separator`.
    ///
    /// Can be used to generate comma-separated list of syntax elements.
    func emitWithSeparators<S: Sequence>(
        _ items: S,
        separator: String,
        _ producer: (S.Element) -> Void
    ) {

        var iterator = items.makeIterator()

        // Emit first item as-is
        guard let first = iterator.next() else {
            return
        }

        producer(first)

        // Subsequent items require a separator
        while let next = iterator.next() {
            emit(separator)
            producer(next)
        }
    }

    /// Backtracks whitespace in the buffer until a non-whitespace character is
    /// found.
    ///
    /// If called while the buffer is filled with only whitespace characters,
    /// the buffer is emptied completely.
    func backtrackWhitespace() {
        buffer = buffer.trimmingWhitespaceTrail()
    }

    /// Ensures the last character of the buffer is a line feed (\n). If not, a
    /// line feed is pushed.
    func ensureNewline() {
        if !isOnNewline() {
            emitRaw("\n")
        }
    }

    /// Ensures at least one space or line feed character is present at the end
    /// of the buffer, emitting one if none is found.
    func ensureSpaceSeparator() {
        if !isOnSpaceSeparator() {
            emitSpaceSeparator()
        }
    }
    
    /// Ensures an empty line sits in the end of the buffer.
    /// If the buffer is empty, no change is made.
    func ensureEmptyLine() {
        guard !buffer.isEmpty else { return }
        
        ensureDoubleNewline()
    }

    /// Ensures the last two characters of the buffer are line feeds (\n\n). If
    /// not, line feeds are pushed to the end of the buffer until there are
    /// at least two.
    func ensureDoubleNewline() {
        guard isOnNewline() else {
            emitRaw("\n")
            emitRaw("\n")
            return
        }

        if !isOnDoubleNewline() {
            emitRaw("\n")
        }
    }

    /// Pre-fills the current line with indentation, if it is empty.
    func ensureIndentation() {
        if isOnNewline() || buffer.isEmpty {
            emitRaw(indentationString())
        }
    }

    /// Queues a given prefix to the appended to the next non-empty line 
    func queuePrefix(_ prefix: PendingPrefix) {
        pendingPrefix.append(prefix)
    }

    /// Provides settings for a `SwiftProducer` instance.
    public struct Settings {
        /// Default settings instance
        public static let `default` = Settings(
            outputExpressionTypes: false,
            printIntentionHistory: false,
            emitObjcCompatibility: false
        )
        
        /// If `true`, when outputting expression statements, print the resulting
        /// type of the expression before the expression statement as a comment
        /// for inspection.
        public var outputExpressionTypes: Bool
        
        /// If `true`, when outputting final intentions, print any history
        /// information tracked on its `IntentionHistory` property before the
        /// intention's declaration as a comment for inspection.
        public var printIntentionHistory: Bool
        
        /// If `true`, `@objc` attributes and `: NSObject` are emitted for
        /// declarations during output.
        ///
        /// This may increase compatibility with previous Objective-C code when
        /// compiled and executed.
        public var emitObjcCompatibility: Bool
        
        public init(
            outputExpressionTypes: Bool,
            printIntentionHistory: Bool,
            emitObjcCompatibility: Bool
        ) {
            
            self.outputExpressionTypes = outputExpressionTypes
            self.printIntentionHistory = printIntentionHistory
            self.emitObjcCompatibility = emitObjcCompatibility
        }
        
        /// To ease modifications of single parameters from default settings
        /// without having to create a temporary variable first
        public func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
            var copy = self
            copy[keyPath: keyPath] = value
            return copy
        }
    }

    /// An object that watches for changes made to the buffer between points, and
    /// emits content conditionally only if changes to the buffer where made since
    /// the last point monitored.
    class ConditionalEmitter {
        // TODO: Change the state being watched to something lighter like a simple counter integer on SwiftProducer
        typealias State = String

        private let producer: SwiftProducer
        private var state: State

        init(producer: SwiftProducer) {
            self.producer = producer
            self.state = producer.buffer
        }

        private func _recordState() {
            self.state = producer.buffer
        }

        private func _hasChanged() -> Bool {
            self.state != producer.buffer
        }

        /// Conditionally emits a given text if the buffer has been changed
        /// since this object was created, or since the last time it emitted
        /// something.
        func emit(_ text: String) {
            if _hasChanged() {
                producer.emit(text)
                _recordState()
            }
        }

        /// Conditionally calls `ensureEmptyLine` on the producer if the buffer
        /// has been changed since this object was created, or since the last
        /// time it emitted something.
        func ensureEmptyLine() {
            if _hasChanged() {
                producer.ensureEmptyLine()
                _recordState()
            }
        }
    }

    enum IndentationMode {
        case spaces(Int)
        case tabs(Int)

        var asString: String {
            switch self {
            case .spaces(let count):
                return String(repeating: " ", count: count)

            case .tabs(let count):
                return String(repeating: "\t", count: count)
            }
        }
    }

    /// Specifies a line to prefixed to the next non-empty line emitted by the
    /// producer. Used to suffix declarations with comments.
    enum PendingPrefix {
        case lineComment(String)
        case docComment(String)
    }
}

// MARK: - Public entry points

public extension SwiftProducer {
    /// Generates an entire source file syntax from a given file intention.
    func generateFile(_ file: FileGenerationIntention) -> SourceFileSyntax {
        resetState()

        emit(file)

        finishBuffer()
        return Parser.parse(source: buffer)
    }
}

// MARK: - Misc helpers

extension SwiftProducer {
    /// Invokes the contents of the given block while temporarily indenting the
    /// producer by one.
    func indented(_ block: () -> Void) {
        indent()
        block()
        unindent()
    }

    /// Emits a left brace, a newline, indents by one, invokes `block` and
    /// finally unindent before emitting a right brace on a separate line:
    ///
    /// ```
    /// {
    /// <block()>
    /// }
    /// ```
    func emitBlock(_ block: () -> Void) {
        emitLine("{")
        indented(block)
        ensureNewline()
        emitLine("}")
    }

    /// Emits a left brace, a newline, indents by one, invokes `block` and
    /// finally unindent before emitting a right brace on a separate line,
    /// removing any empty line trailing the right brace:
    ///
    /// ```
    /// {
    /// <block()>
    /// }
    /// ```
    /// 
    /// Used to generate type member blocks.
    func emitMembersBlock(_ block: () -> Void) {
        emitLine("{")
        indented(block)
        backtrackWhitespace()
        ensureNewline()
        emitLine("}")
    }

    /// Emits a left brace, a newline, and a right brace on a separate line:
    ///
    /// ```
    /// {
    /// }
    /// ```
    func emitEmptyBlock() {
        emitLine("{")
        ensureNewline()
        emitLine("}")
    }
}

// MARK: - SwiftSyntax

extension SwiftProducer {
    func emit(_ type: SwiftType) {
        let producer = SwiftTypeStringProducer()
        emit(producer.convert(type))
    }

    func emitReturnType(_ type: SwiftType) {
        switch type {
        case .nullabilityUnspecified(let inner):
            emit(.optional(inner))
        default:
            emit(type)
        }
    }

    func emit(_ comment: SwiftComment) {
        emitLine(comment.string)
    }

    func emit(_ parameters: [ParameterSignature]) {
        emitWithSeparators(parameters, separator: ", ", emit)
    }

    func emit(_ parameter: ParameterSignature) {
        if let label = parameter.label {
            if label != parameter.name {
                emit(label)
                emitSpaceSeparator()
            }
        } else {
            emit("_")
            emitSpaceSeparator()
        }

        emit(parameter.name)
        emit(": ")
        emit(parameter.type)
        if parameter.isVariadic {
            emit("...")
        }
        
        if parameter.hasDefaultValue {
            emit(" = <default>")
        }
    }

    func emit(_ signature: FunctionSignature) {
        emit(signature.name)

        emit("(")
        emit(signature.parameters)
        emit(")")

        if signature.returnType != .void {
            emit(" -> ")
            emitReturnType(signature.returnType)
        }
    }

    func emit(_ statement: Statement) {
        let visitor = StatementEmitter(producer: self)
        visitor.visitStatement(statement)
    }

    func emit(_ statement: CompoundStatement) {
        let visitor = StatementEmitter(producer: self)
        visitor.emitCodeBlock(statement)
    }

    func emit(_ expression: Expression) {
        let visitor = StatementEmitter(producer: self)
        visitor.visitExpression(expression)
    }
}

// MARK: - KnownType

extension SwiftProducer {
    func emit(_ attribute: KnownAttribute, inline: Bool) {
        emit("@\(attribute.name)")
        if let parameters = attribute.parameters {
            emit("(\(parameters))")
        }

        if !inline {
            emitNewline()
        } else {
            emit(" ")
        }
    }
}

// MARK: - SwiftVariableDeclaration

extension SwiftProducer {
    func emit(_ modifier: SwiftDeclarationModifier, inline: Bool) {
        emit(modifier.description)

        if !inline {
            emitNewline()
        } else {
            emit(" ")
        }
    }

    func emit(_ pattern: SwiftVariableDeclaration.PatternBindingElement) {
        emit(pattern.name)
        if let type = pattern.type {
            emit(": ")
            emit(type)
        }
        if let initialization = pattern.initialization {
            emit(" = ")
            emit(initialization)
        }
    }

    func emit(_ accessor: SwiftVariableDeclaration.Accessor) {
        switch accessor {
        case .computed(let body):
            emit(body)

        case .getter(let getter, let setter):
            emitBlock {
                // Getter
                emit("get")
                emitSpaceSeparator()
                emit(getter)

                // Setter
                emit("set")
                if setter.valueIdentifier != "newValue" {
                    emit("(\(setter.valueIdentifier))")
                }
                emitSpaceSeparator()
                emit(setter.body)
            }
        }
    }

    func emit(_ decl: SwiftVariableDeclaration) {
        for attribute in decl.attributes {
            emit(attribute, inline: true)
        }
        for modifier in decl.modifiers {
            emit(modifier, inline: true)
        }

        emit(decl.constant ? "let" : "var")
        emitSpaceSeparator()

        switch decl.kind {
        case .single(let pattern, let accessor):
            emit(pattern)
            if let accessor {
                ensureSpaceSeparator()
                emit(accessor)
            } else {
                emitNewline()
            }
            
        case let .multiple(patterns):
            emitWithSeparators(patterns, separator: ", ", emit)
            emitNewline()
        }
    }
}

// MARK: - Intention commons

extension SwiftProducer {
    func emitIntentionCommons(_ intention: FromSourceIntention) {
        emitHistoryTracking(intention)
        emitComments(intention)
        emitAttributes(intention, inline: false)
        emitModifiers(intention)
    }

    func emitHistoryTracking(_ intention: Intention) {
        guard settings.printIntentionHistory else {
            return
        }

        for entry in intention.history.entries {
            emitPrefix(.lineComment(entry.summary))
        }
    }

    func emitComments(_ intention: FromSourceIntention) {
        for comment in intention.precedingComments {
            emit(comment)
        }
    }

    func emitInheritanceClause(_ intention: TypeGenerationIntention) {
        var clauses: [String] =
            (intention.supertype.map({ [$0.asSwiftType.description] }) ?? [])
            + intention.protocols.map(\.protocolName)

        // Special case: Enums have their raw values as the first inheritance
        if let intention = intention as? EnumGenerationIntention {
            clauses.insert(intention.rawValueType.description, at: 0)
        }

        // TODO: This should not be done here, but in an IntentionPass
        // Special case: Emit NSObjectProtocol as inheritances to protocol declarations
        // in Objective-C-compatibility mode
        if intention is ProtocolGenerationIntention {
            if shouldEmitObjcAttribute(intention) {
                if !clauses.contains("NSObjectProtocol") {
                    clauses.insert("NSObjectProtocol", at: 0)
                }
            } else if !settings.emitObjcCompatibility {
                clauses.removeAll(where: { $0 == "NSObjectProtocol" })
            }
        }

        guard !clauses.isEmpty else {
            return
        }

        emit(": ")

        emitWithSeparators(clauses, separator: ", ", emit)
    }

    func emitAttributes(_ intention: IntentionProtocol, inline: Bool) {
        guard let intention = intention as? IntentionProtocol & AttributeTaggableObject else {
            return
        }

        var attributes = intention.knownAttributes

        // TODO: This should not be done here, but in an IntentionPass
        if shouldEmitObjcAttribute(intention) {
            attributes.append(KnownAttribute(name: "objc"))
        }

        for attribute in attributes {
            emit(attribute, inline: inline)
        }
    }

    func emitModifiers(_ intention: Intention) {
        let modifiers = modifiers(for: intention)

        for modifier in modifiers {
            emit(modifier, inline: true)
        }
    }
    
    func shouldEmitObjcAttribute(_ intention: IntentionProtocol) -> Bool {
        if !settings.emitObjcCompatibility {
            // Protocols which feature optional members must be emitted with @objc
            // to maintain compatibility; same for method/properties
            if let _protocol = intention as? ProtocolGenerationIntention {
                if _protocol.methods.any(\.optional)
                    || _protocol.properties.any(\.optional) {
                    return true
                }
            }
            if let property = intention as? ProtocolPropertyGenerationIntention {
                return property.isOptional
            }
            if let method = intention as? ProtocolMethodGenerationIntention {
                return method.isOptional
            }
            
            return false
        }
        
        if intention is EnumCaseGenerationIntention {
            return false
        }
        if intention is PropertyGenerationIntention {
            return true
        }
        if intention is InitGenerationIntention {
            return true
        }
        if intention is MethodGenerationIntention {
            return true
        }
        if let type = intention as? TypeGenerationIntention,
            type.kind != .struct {
            return true
        }
        
        return false
    }

    func modifiers(for intention: Intention) -> [SwiftDeclarationModifier] {
        let applier = ModifiersDecoratorApplier.makeDefaultDecoratorApplier()
        return applier.modifiers(for: intention)
    }

    func modifiers(for intention: ValueStorageIntention) -> [SwiftDeclarationModifier] {
        let applier = ModifiersDecoratorApplier.makeDefaultDecoratorApplier()
        return applier.modifiers(for: intention)
    }

    func modifiers(for intention: StatementVariableDeclaration) -> [SwiftDeclarationModifier] {
        let applier = ModifiersDecoratorApplier.makeDefaultDecoratorApplier()
        return applier.modifiers(for: intention)
    }

    func attributes(for intention: Intention) -> [KnownAttribute] {
        if let intention = intention as? MemberGenerationIntention {
            return intention.knownAttributes
        }

        return []
    }

    func attributes(for intention: ValueStorageIntention) -> [KnownAttribute] {
        var attributes: [KnownAttribute] = []

        if shouldEmitObjcAttribute(intention) {
            attributes.append(KnownAttribute(name: "objc"))
        }

        if let intention = intention as? MemberGenerationIntention {
            attributes.append(contentsOf: intention.knownAttributes)
        }

        return attributes
    }
}

// MARK: - FunctionBodyIntention

extension SwiftProducer {
    func emit(_ intention: FunctionBodyIntention) {
        emit(intention.body)
    }
}

// MARK: - FileGenerationIntention

extension SwiftProducer {
    func emit(_ file: FileGenerationIntention) {
        for module in file.importDirectives {
            emitLine("import \(module)")
        }

        if !file.headerComments.isEmpty {
            ensureEmptyLine()
            for comment in file.headerComments {
                emitComment(comment)
            }
        }

        let spacer = startConditionalEmitter()

        // Typealias
        for intention in file.typealiasIntentions {
            emit(intention)
        }

        spacer.ensureEmptyLine()

        // Enums
        for intention in file.enumIntentions {
            emit(intention)
        }

        spacer.ensureEmptyLine()

        // Structs
        for intention in file.structIntentions {
            emit(intention)
        }

        spacer.ensureEmptyLine()

        // Global variables
        for intention in file.globalVariableIntentions {
            emit(intention)
        }

        spacer.ensureEmptyLine()
        
        // Global functions
        for intention in file.globalFunctionIntentions {
            emit(intention)
        }

        spacer.ensureEmptyLine()

        // Protocols
        for intention in file.protocolIntentions {
            emit(intention)
        }

        spacer.ensureEmptyLine()

        // Classes
        for intention in file.classIntentions {
            emit(intention)
        }

        spacer.ensureEmptyLine()
        
        // Extensions
        for intention in file.extensionIntentions {
            emit(intention)
        }
    }
}

// MARK: - TypealiasGenerationIntention

extension SwiftProducer {
    func emit(_ intention: TypealiasIntention) {
        emitIntentionCommons(intention)

        emit("typealias \(intention.name) = ")
        emit(intention.fromType)
        emitNewline()
    }
}

// MARK: - GlobalVariableGenerationIntention

extension SwiftProducer {
    func emit(_ intention: GlobalVariableGenerationIntention) {
        emitHistoryTracking(intention)
        emitComments(intention)

        let decl = makeDeclaration(intention)
        emit(decl)
    }
}

// MARK: - EnumGenerationIntention

extension SwiftProducer {
    func emit(_ intention: EnumGenerationIntention) {
        emitIntentionCommons(intention)

        emit("enum \(intention.typeName)")
        emitInheritanceClause(intention)
        ensureSpaceSeparator()
        emitMembersBlock {
            intention.cases.forEach(emit(_:))
        }
    }

    func emit(_ intention: EnumCaseGenerationIntention) {
        emitIntentionCommons(intention)

        emit("case \(intention.name)")
        if let rawValue = intention.expression {
            emit(" = ")
            emit(rawValue)
        }

        emitNewline()
    }
}

// MARK: - StructGenerationIntention

extension SwiftProducer {
    func emit(_ intention: StructGenerationIntention) {
        emitIntentionCommons(intention)

        emit("struct \(intention.typeName)")
        emitInheritanceClause(intention)
        ensureSpaceSeparator()
        emitMembersBlock {
            let emitter = startConditionalEmitter()
            emitIvars(intention)
            emitProperties(intention)
            emitSubscripts(intention)

            emitter.ensureEmptyLine()
            emitInitializers(intention)
            
            emitter.ensureEmptyLine()
            emitMethods(intention)
        }
    }
}

// MARK: - ProtocolGenerationIntention

extension SwiftProducer {
    func emit(_ intention: ProtocolGenerationIntention) {
        emitIntentionCommons(intention)

        emit("protocol \(intention.typeName)")
        emitInheritanceClause(intention)
        ensureSpaceSeparator()
        emitMembersBlock {
            let emitter = startConditionalEmitter()
            emitProperties(intention)
            emitSubscripts(intention)

            emitter.ensureEmptyLine()
            emitInitializers(intention)

            emitter.ensureEmptyLine()
            emitMethods(intention)
        }
    }
}

// MARK: - ClassGenerationIntention

extension SwiftProducer {
    func emit(_ intention: ClassGenerationIntention) {
        emitIntentionCommons(intention)

        emit("class \(intention.typeName)")
        emitInheritanceClause(intention)
        ensureSpaceSeparator()
        emitMembersBlock {
            let emitter = startConditionalEmitter()
            
            emitIvars(intention)
            emitProperties(intention)
            emitSubscripts(intention)
            
            emitter.ensureEmptyLine()
            emitInitializers(intention)
            
            emitter.ensureEmptyLine()
            if let deinitIntention = intention.deinitIntention {
                emit(deinitIntention)
            }
            
            emitter.ensureEmptyLine()
            emitMethods(intention)
        }
    }
}

// MARK: - ClassExtensionGenerationIntention

extension SwiftProducer {
    func emit(_ intention: ClassExtensionGenerationIntention) {
        if
            let categoryName = intention.categoryName,
            !categoryName.trimmingWhitespace().isEmpty
        {
            emitPrefix(.lineComment("MARK: - \(categoryName)"))
        } else {
            emitPrefix(.lineComment("MARK: -"))
        }

        emitIntentionCommons(intention)

        emit("extension \(intention.typeName)")
        emitInheritanceClause(intention)
        ensureSpaceSeparator()

        emitMembersBlock {
            let emitter = startConditionalEmitter()

            emitProperties(intention)
            emitSubscripts(intention)

            emitter.ensureEmptyLine()
            emitMethods(intention)
        }
    }
}

// MARK: - GlobalFunctionGenerationIntention

extension SwiftProducer {
    func emit(_ intention: GlobalFunctionGenerationIntention) {
        emitIntentionCommons(intention)

        emit("func ")
        emit(intention.signature)
        emitSpaceSeparator()
        if let body = intention.functionBody {
            emit(body)
        } else {
            emitBlock({})
        }
    }
}

// MARK: - TypeGenerationIntention

extension SwiftProducer {
    func emitIvars(_ intention: InstanceVariableContainerIntention) {
        for ivar in intention.instanceVariables {
            emit(ivar)
        }
    }

    func emitProperties(_ intention: TypeGenerationIntention) {
        for property in intention.properties {
            emit(property)
        }
    }

    func emitSubscripts(_ intention: TypeGenerationIntention) {
        for intention in intention.subscripts {
            emit(intention)
        }
    }

    func emitInitializers(_ intention: TypeGenerationIntention) {
        for initializer in intention.constructors {
            emit(initializer)
        }
    }

    func emitMethods(_ intention: TypeGenerationIntention) {
        for method in intention.methods {
            emit(method)
        }
    }

    func emit(_ intention: SubscriptGenerationIntention) {
        emitIntentionCommons(intention)

        emit("subscript")
        emit("(")
        emit(intention.parameters)
        emit(") -> ")
        emitReturnType(intention.returnType)
        emitSpaceSeparator()

        let accessor: SwiftVariableDeclaration.Accessor

        switch intention.mode {
        case .getter(let body):
            accessor = .computed(body.body)

        case .getterAndSetter(let getter, let setter):
            accessor = .getter(
                getter.body,
                setter: .init(
                    valueIdentifier: setter.valueIdentifier,
                    body: setter.body.body
                )
            )
        }

        emit(accessor)
    }

    func emit(_ intention: PropertyGenerationIntention) {
        emitHistoryTracking(intention)
        emitComments(intention)

        if intention is ProtocolPropertyGenerationIntention {
            emitAttributes(intention, inline: true)
            emitModifiers(intention)

            emit("var \(intention.name)")
            emit(": ")
            emit(intention.type)
            ensureSpaceSeparator()

            if intention.isConstant || intention.isReadOnly {
                emit("{ get }")
            } else {
                emit("{ get set }")
            }
            emitNewline()
        } else {
            let decl = makeDeclaration(intention)
            emit(decl)
        }
    }

    func emit(_ intention: InstanceVariableGenerationIntention) {
        emitHistoryTracking(intention)
        emitComments(intention)

        let decl = makeDeclaration(intention)
        emit(decl)
    }

    func emit(_ intention: InitGenerationIntention) {
        emitIntentionCommons(intention)

        emit("init")

        if intention.isFallible {
            emit("?")
        }

        emit("(")
        emit(intention.parameters)
        emit(")")

        // TODO: Create a ProtocolInitGenerationIntention for this purpose
        if intention.parent is ProtocolGenerationIntention {
            emitNewline()
        } else {
            ensureSpaceSeparator()
            if let body = intention.functionBody?.body {
                emit(body)
            } else {
                emitEmptyBlock()
            }
        }
    }

    func emit(_ intention: DeinitGenerationIntention) {
        emitIntentionCommons(intention)

        emit("deinit")

        ensureSpaceSeparator()
        if let body = intention.functionBody?.body {
            emit(body)
        } else {
            emitEmptyBlock()
        }
    }

    func emit(_ intention: MethodGenerationIntention) {
        emitIntentionCommons(intention)

        emit("func ")
        emit(intention.signature)

        if intention is ProtocolMethodGenerationIntention {
            emitNewline()
        } else {
            ensureSpaceSeparator()
            if let body = intention.functionBody?.body {
                emit(body)
            } else {
                emitEmptyBlock()
            }
        }
    }
}

// MARK: - Variable declaration generation

extension SwiftProducer {
    func makeDeclaration(_ stmtDecl: StatementVariableDeclaration) -> SwiftVariableDeclaration {
        let decl = makeDeclaration(
            name: stmtDecl.identifier,
            storage: stmtDecl.storage,
            attributes: [],
            intention: nil,
            modifiers: modifiers(for: stmtDecl),
            initialization: stmtDecl.initialization
        )
        
        return decl
    }
    
    func makeDeclaration(_ intention: ValueStorageIntention) -> SwiftVariableDeclaration {
        var accessors: SwiftVariableDeclaration.Accessor?
        if let intention = intention as? PropertyGenerationIntention {
            switch intention.mode {
            case .asField:
                accessors = nil

            case .computed(let body):
                accessors = .computed(body.body)

            case .property(let getter, let setter):
                accessors = .getter(
                    getter.body,
                    setter: .init(
                        valueIdentifier: setter.valueIdentifier,
                        body: setter.body.body
                    )
                )
            }
        }
        
        return makeDeclaration(
            name: intention.name,
            storage: intention.storage,
            attributes: attributes(for: intention),
            intention: intention,
            modifiers: modifiers(for: intention),
            accessors: accessors,
            initialization: _initialValue(for: intention)
        )
    }
    
    func makeDeclaration(
        name: String,
        storage: ValueStorage,
        attributes: [KnownAttribute],
        intention: IntentionProtocol?,
        modifiers: [SwiftDeclarationModifier],
        accessors: SwiftVariableDeclaration.Accessor? = nil,
        initialization: Expression? = nil
    ) -> SwiftVariableDeclaration {
        
        var patternBinding = makePatternBinding(
            name: name,
            type: storage.type,
            initialization: initialization
        )
        
        if
            delegate?.swiftProducer(
                self,
                shouldEmitTypeFor: storage,
                intention: intention,
                initialValue: initialization
            ) == false
        {
            patternBinding.type = nil
        }
        
        return SwiftVariableDeclaration(
            constant: storage.isConstant,
            attributes: attributes,
            modifiers: modifiers,
            kind: .single(
                pattern: patternBinding,
                accessors
            )
        )
    }
    
    func makePatternBinding(_ intention: ValueStorageIntention) -> SwiftVariableDeclaration.PatternBindingElement {
        SwiftVariableDeclaration.PatternBindingElement(
            name: intention.name,
            type: intention.type,
            intention: intention,
            initialization: _initialValue(for: intention)
        )
    }

    func makePatternBinding(
        name: String,
        type: SwiftType?,
        initialization: Expression?
    ) -> SwiftVariableDeclaration.PatternBindingElement {
        
        SwiftVariableDeclaration.PatternBindingElement(
            name: name,
            type: type,
            intention: nil,
            initialization: initialization
        )
    }

    func _initialValue(for intention: ValueStorageIntention) -> Expression? {
        if let intention = intention.initialValue {
            return intention
        }
        if intention is GlobalVariableGenerationIntention {
            return nil
        }
        if let intention = intention as? MemberGenerationIntention {
            if intention.type?.kind != .class {
                return nil
            }
        }
        
        return delegate?.swiftProducer(self, initialValueFor: intention)
    }
}

// MARK: - Internals

fileprivate class StatementEmitter: StatementVisitor, ExpressionVisitor {
    /// A reference to the last statement emitted at the current block level.
    //private var _latestStatement: Statement?

    /// A stack of latest statements seen.
    /// Each entry is the latest statement seen across closure boundaries.
    private var _latestStatementsStack: [Statement?] = [nil]

    let producer: SwiftProducer

    internal init(producer: SwiftProducer) {
        self.producer = producer
    }

    // MARK: Alternative syntax checkers

    /// Checks whether a function call operation is a candidate for trailing
    /// closure syntax transformation.
    ///
    /// Closure parameters can only be trailed if they are the last parameter
    /// of a call, and don't immediately succeed another closure parameter.
    func isTrailingClosureCandidate(_ op: FunctionCallPostfix) -> Bool {
        guard !op.arguments.isEmpty else {
            return false
        }
        guard op.arguments.last?.expression.isBlock == true else {
            return false
        }

        if op.arguments.count > 1 {
            if op.arguments[op.arguments.count - 2].expression.isBlock == true {
                return false
            }
        }

        return true
    }

    func isShorthandClosureCandidate(_ exp: BlockLiteralExpression) -> Bool {
        let hasParameters = !exp.parameters.isEmpty
        
        return !closureRequiresSignature(exp) && hasParameters
    }

    func closureRequiresSignature(_ exp: BlockLiteralExpression) -> Bool {
        exp.resolvedType == nil || exp.resolvedType != exp.expectedType
    }

    func _latestStatement() -> Statement? {
        return _latestStatementsStack[_latestStatementsStack.count - 1]
    }

    func _shouldEmitSpacing(_ nextStmt: Statement) -> Bool {
        guard let latest = _latestStatement() else {
            return false
        }

        if (latest is ExpressionsStatement) && (nextStmt is ExpressionsStatement) {
            return false
        }
        if (latest is VariableDeclarationsStatement) && (nextStmt is VariableDeclarationsStatement) {
            return false
        }

        return true
    }

    func shouldEmitSpacing(_ stmt1: Statement?, _ stmt2: Statement) -> Bool {
        guard var stmt1 else {
            return false
        }
        var stmt2 = stmt2

        // If one of the statements is a compound statement, use the statements
        // at each end for the check
        if let compound = stmt1.asCompound {
            guard let last = compound.statements.last else {
                return false
            }

            stmt1 = last
        }
        if let compound = stmt2.asCompound {
            guard let first = compound.statements.first else {
                return false
            }

            stmt2 = first
        }

        if (stmt1 is ExpressionsStatement) && (stmt2 is ExpressionsStatement) {
            return false
        }
        if (stmt1 is VariableDeclarationsStatement) && (stmt2 is VariableDeclarationsStatement) {
            return false
        }

        return true
    }

    func pushClosureStack() {
        _latestStatementsStack.append(nil)
    }

    func popClosureStack() {
        _latestStatementsStack.removeLast()
    }

    func recordLatest(_ nextStmt: Statement) {
        if _shouldEmitSpacing(nextStmt) {
            emitNewline()
        }

        _latestStatementsStack[_latestStatementsStack.count - 1] = nextStmt
    }

    // MARK: Convenience wrappers

    func emit(_ text: String) {
        producer.emit(text)
    }

    func emitLine(_ text: String) {
        producer.emitLine(text)
    }

    func emit(_ type: SwiftType) {
        producer.emit(type)
    }

    func emitReturnType(_ type: SwiftType) {
        producer.emitReturnType(type)
    }

    func emitSpaceSeparator() {
        producer.emitSpaceSeparator()
    }

    func emitNewline() {
        producer.emitNewline()
    }

    func emitStatements(_ stmts: [Statement]) {
        for stmt in stmts {
            visitStatement(stmt)
        }
    }

    func emitComments(_ comments: [SwiftComment]) {
        comments.forEach(producer.emit)
    }

    func emitCodeBlock(_ stmt: CompoundStatement) {
        pushClosureStack()
        defer { popClosureStack() }

        producer.emitBlock {
            visitCompound(stmt)
        }
    }

    // MARK: Statements

    func visitPattern(_ ptn: Pattern) {
        switch ptn {
        case .expression(let exp):
            visitExpression(exp)
            
        case .tuple(let patterns):
            emit("(")
            producer.emitWithSeparators(patterns, separator: ", ", visitPattern)
            emit(")")
        
        case .identifier(let ident):
            emit("let ")
            emit(ident)
            
        case .wildcard:
            emit("_")
        }
    }

    func visitStatement(_ stmt: Statement) {
        if !stmt.isCompound {
            recordLatest(stmt)
            emitComments(stmt.comments)
        }
        if let label = stmt.label {
            if stmt.isLabelableStatementType {
                emitLine("\(label):")
            } else {
                emitLine("// \(label):")
            }
        }
        stmt.accept(self)
        if let trailing = stmt.trailingComment {
            producer.backtrackWhitespace()
            emitSpaceSeparator()
            producer.emit(trailing)
        }
        producer.ensureNewline()
    }

    func visitCompound(_ stmt: CompoundStatement) {
        emitComments(stmt.comments)

        if !stmt.comments.isEmpty && !stmt.statements.isEmpty {
            producer.ensureEmptyLine()
        }

        emitStatements(stmt.statements)
    }

    func visitIf(_ stmt: IfStatement) {
        emit("if ")
        if let pattern = stmt.pattern {
            visitPattern(pattern)
            emit(" = ")
        }
        visitExpression(stmt.exp)
        emitSpaceSeparator()

        emitCodeBlock(stmt.body)

        if let elseBody = stmt.elseBody {
            // Backtrack to closing brace
            producer.backtrackWhitespace()
            emit(" else ")

            // Collapse else-if chains
            if
                elseBody.statements.count == 1,
                let elseIf = elseBody.statements.first?.asIf
            {
                visitIf(elseIf)
            } else {
                emitCodeBlock(elseBody)
            }
        }
    }

    func visitSwitch(_ stmt: SwitchStatement) {
        emit("switch ")
        visitExpression(stmt.exp)
        emitLine(" {")
        
        stmt.cases.forEach { visitSwitchCase($0) }

        if let defaultCase = stmt.defaultCase {
            visitSwitchDefaultCase(defaultCase)
        }

        producer.ensureNewline()
        emitLine("}")
    }

    func visitSwitchCase(_ switchCase: SwitchCase) {
        emit("case ")
        producer.emitWithSeparators(switchCase.patterns, separator: ", ", visitPattern)
        emitLine(":")
        producer.indented {
            pushClosureStack()
            emitStatements(switchCase.statements)
            popClosureStack()
        }
    }

    func visitSwitchDefaultCase(_ defaultCase: SwitchDefaultCase) {
        emitLine("default:")
        producer.indented {
            pushClosureStack()
            emitStatements(defaultCase.statements)
            popClosureStack()
        }
    }

    func visitWhile(_ stmt: WhileStatement) {
        emit("while ")
        visitExpression(stmt.exp)
        producer.emitSpaceSeparator()
        emitCodeBlock(stmt.body)
    }

    func visitRepeatWhile(_ stmt: RepeatWhileStatement) {
        emit("repeat ")
        emitCodeBlock(stmt.body)
        producer.backtrackWhitespace()
        emit(" while ")
        visitExpression(stmt.exp)
    }

    func visitFor(_ stmt: ForStatement) {
        emit("for ")

        switch stmt.pattern {
        case .identifier(let ident):
            emit(ident)
        default:
            visitPattern(stmt.pattern)
        }

        emit(" in ")
        visitExpression(stmt.exp)
        emitSpaceSeparator()

        emitCodeBlock(stmt.body)
    }

    func visitDo(_ stmt: DoStatement) {
        emit("do ")
        emitCodeBlock(stmt.body)

        for catchBlock in stmt.catchBlocks {
            visitCatchBlock(catchBlock)
        }
    }

    func visitCatchBlock(_ block: CatchBlock) {
        producer.backtrackWhitespace()
        emit(" catch ")

        if let pattern = block.pattern {
            visitPattern(pattern)
            emitSpaceSeparator()
        }

        emitCodeBlock(block.body)
    }

    func visitDefer(_ stmt: DeferStatement) {
        emit("defer ")
        emitCodeBlock(stmt.body)
    }

    func visitReturn(_ stmt: ReturnStatement) {
        emit("return")
        if let exp = stmt.exp {
            emitSpaceSeparator()
            visitExpression(exp)
        }
    }

    func visitBreak(_ stmt: BreakStatement) {
        emit("break")
        if let targetLabel = stmt.targetLabel {
            emitSpaceSeparator()
            emit(targetLabel)
        }
    }

    func visitFallthrough(_ stmt: FallthroughStatement) {
        emit("fallthrough")
    }

    func visitContinue(_ stmt: ContinueStatement) {
        emit("continue")
        if let targetLabel = stmt.targetLabel {
            emitSpaceSeparator()
            emit(targetLabel)
        }
    }

    func visitExpressions(_ stmt: ExpressionsStatement) {
        producer.emitWithSeparators(stmt.expressions, separator: "\n") { exp in
            if producer.settings.outputExpressionTypes {
                emitComments([
                    .line("// type: \(exp.resolvedType?.description ?? "<nil>")")
                ])
            }

            visitExpression(exp)
        }
    }
    
    func visitVariableDeclarations(_ stmt: VariableDeclarationsStatement) {
        let declarations = group(stmt.decl.map(producer.makeDeclaration))

        for (i, decl) in declarations.enumerated() {
            if producer.settings.outputExpressionTypes {
                let declType = stmt.decl[i].type
                producer.emitComment("decl type: \(declType)")
                
                if let exp = stmt.decl[i].initialization {
                    producer.emitComment("init type: \(exp.resolvedType ?? "<nil>")")
                }
            }

            producer.emit(decl)
        }
    }
    
    func visitStatementVariableDeclaration(_ decl: StatementVariableDeclaration) {
        
    }

    func visitLocalFunction(_ stmt: LocalFunctionStatement) {
        emit("func ")
        producer.emit(stmt.function.signature)
        emitSpaceSeparator()
        emitCodeBlock(stmt.function.body)
    }
    
    func visitThrow(_ stmt: ThrowStatement) {
        emit("throw ")
        visitExpression(stmt.exp)
    }
    
    func visitUnknown(_ stmt: UnknownStatement) {
        emitLine("/*")
        emitLine(stmt.context.context)
        emitLine("*/")
    }

    // MARK: Expressions

    func parenthesizeIfRequired(_ exp: Expression) {
        if exp.requiresParens { emit("(") }
        visitExpression(exp)
        if exp.requiresParens { emit(")") }
    }

    func visitExpression(_ exp: Expression) {
        exp.accept(self)
    }

    func visitAssignment(_ exp: AssignmentExpression) {
        visitExpression(exp.lhs)
        if exp.op.requiresSpacing {
            emit(" \(exp.op.description) ")
        } else {
            emit(exp.op.description)
        }
        visitExpression(exp.rhs)
    }

    func visitBinary(_ exp: BinaryExpression) {
        visitExpression(exp.lhs)
        if exp.op.requiresSpacing {
            emit(" \(exp.op.description) ")
        } else {
            emit(exp.op.description)
        }
        visitExpression(exp.rhs)
    }

    func visitUnary(_ exp: UnaryExpression) {
        emit(exp.op.description)
        parenthesizeIfRequired(exp.exp)
    }

    func visitSizeOf(_ exp: SizeOfExpression) {
        switch exp.value {
        case .expression(let innerExp):
            if case .metatype(let inner) = innerExp.resolvedType {
                emit("MemoryLayout<")
                emit(inner)
                emit(">.size")
            } else {
                emit("MemoryLayout.size(ofValue: ")
                visitExpression(innerExp)
                emit(")")
            }
            
        case .type(let type):
            emit("MemoryLayout<")
            emit(type)
            emit(">.size")
        }
    }

    func visitPrefix(_ exp: PrefixExpression) {
        emit(exp.op.description)
        parenthesizeIfRequired(exp.exp)
    }

    func visitFunctionArguments(_ arguments: [FunctionArgument]) {
        producer.emitWithSeparators(arguments, separator: ", ") { argument in
            if let label = argument.label {
                emit("\(label): ")
            }

            visitExpression(argument.expression)
        }
    }

    func visitPostfix(_ exp: PostfixExpression) {
        parenthesizeIfRequired(exp.exp)

        switch exp.op.optionalAccessKind {
        case .none:
            break
        case .forceUnwrap:
            emit("!")
        case .safeUnwrap:
            emit("?")
        }
        
        switch exp.op {
        case let fc as FunctionCallPostfix:
            // If the last argument is a block type, close the
            // parameters list earlier and use the block as a
            // trailing closure.
            // Exception: If the second-to-last argument is also a closure argument,
            // don't use trailing closure syntax, since it results in confusing-looking
            // code.
            var arguments = fc.arguments
            var trailing: BlockLiteralExpression?
            
            if isTrailingClosureCandidate(fc) {
                trailing = arguments.removeLast().expression.asBlock
            }

            if trailing == nil || !arguments.isEmpty {
                emit("(")
                visitFunctionArguments(arguments)
                emit(")")
            }

            if let trailing {
                emitSpaceSeparator()
                visitBlock(trailing)
            }

        case let sub as SubscriptPostfix:
            emit("[")
            visitFunctionArguments(sub.arguments)
            emit("]")

        case let member as MemberPostfix:
            emit(".")
            emit(member.name)

        default:
            break
        }
    }

    func visitConstant(_ exp: ConstantExpression) {
        emit(exp.description)
    }

    func visitParens(_ exp: ParensExpression) {
        emit("(")
        visitExpression(exp.exp)
        emit(")")
    }

    func visitIdentifier(_ exp: IdentifierExpression) {
        emit(exp.identifier)
    }

    func visitCast(_ exp: CastExpression) {
        parenthesizeIfRequired(exp.exp)
        emit(" as")
        if exp.isOptionalCast {
            emit("?")
        }
        emit(" ")
        emit(exp.type)
    }

    func visitTypeCheck(_ exp: TypeCheckExpression) {
        parenthesizeIfRequired(exp.exp)
        emit(" is ")
        emit(exp.type)
    }

    func visitArray(_ exp: ArrayLiteralExpression) {
        emit("[")
        producer.emitWithSeparators(exp.items, separator: ", ") { item in
            visitExpression(item)
        }
        emit("]")
    }

    func visitDictionary(_ exp: DictionaryLiteralExpression) {
        emit("[")
        producer.emitWithSeparators(exp.pairs, separator: ", ") { pair in
            visitExpression(pair.key)
            emit(": ")
            visitExpression(pair.value)
        }
        if exp.pairs.isEmpty {
            emit(":")
        }
        emit("]")
    }

    func visitBlock(_ exp: BlockLiteralExpression) {
        producer.emitBlock { () -> Void in
            let hasParameters = !exp.parameters.isEmpty
            
            if closureRequiresSignature(exp) || hasParameters {
                producer.backtrackWhitespace()
                emitSpaceSeparator()

                if isShorthandClosureCandidate(exp) {
                    producer.emitWithSeparators(exp.parameters, separator: ", ") { param in
                        emit(param.name)
                    }
                } else {
                    emit("(")
                    producer.emitWithSeparators(exp.parameters, separator: ", ") { param in
                        emit(param.name)
                        emit(": ")
                        emit(param.type)
                    }
                    emit(")")
                    emit(" -> ")
                    emitReturnType(exp.returnType)
                }

                producer.emitLine(" in")
            }

            // Emit body comments
            emitComments(exp.body.comments)

            pushClosureStack()
            emitStatements(exp.body.statements)
            popClosureStack()
        }

        // Backtrack to close brace, allowing closure expressions to sit inline
        // with other expressions
        producer.backtrackWhitespace()
    }

    func visitTernary(_ exp: TernaryExpression) {
        parenthesizeIfRequired(exp.exp)
        emit(" ? ")
        visitExpression(exp.ifTrue)
        emit(" : ")
        visitExpression(exp.ifFalse)
    }

    func visitTuple(_ exp: TupleExpression) {
        emit("(")
        producer.emitWithSeparators(
            exp.elements,
            separator: ", ",
            visitExpression
        )
        emit(")")
    }

    func visitSelector(_ exp: SelectorExpression) {
        emit(exp.description)
    }

    func visitTry(_ exp: TryExpression) {
        emit("try")
        switch exp.mode {
        case .throwable:
            break
        case .optional:
            emit("?")
        case .forced:
            emit("!")
        }

        emitSpaceSeparator()

        parenthesizeIfRequired(exp.exp)
    }

    func visitUnknown(_ exp: UnknownExpression) {
        
    }
}

private func group(_ declarations: [SwiftVariableDeclaration]) -> [SwiftVariableDeclaration] {
    guard let first = declarations.first else {
        return declarations
    }
    
    var result: [SwiftVariableDeclaration] = [first]
    
    for decl in declarations.dropFirst() {
        let last = result[result.count - 1]
        
        if let grouped = groupDeclarations(last, decl) {
            result[result.count - 1] = grouped
        } else {
            result.append(decl)
        }
    }
    
    return result
}

private func groupDeclarations(
    _ decl1: SwiftVariableDeclaration,
    _ decl2: SwiftVariableDeclaration
) -> SwiftVariableDeclaration? {
    
    // Attributed or modified declarations cannot be merged
    guard decl1.attributes.isEmpty && decl2.attributes.isEmpty else {
        return nil
    }
    guard decl1.modifiers.isEmpty && decl2.modifiers.isEmpty else {
        return nil
    }
    
    if decl1.constant != decl2.constant {
        return nil
    }
    
    switch (decl1.kind, decl2.kind) {
    case let (.single(l, nil), .single(r, nil)):
        var decl = decl1
        decl.kind = .multiple(patterns: [l, r])
        
        return decl
        
    case let (.single(l, nil), .multiple(r)):
        var decl = decl1
        decl.kind = .multiple(patterns: [l] + r)
        
        return decl
        
    case let (.multiple(l), .single(r, nil)):
        var decl = decl1
        decl.kind = .multiple(patterns: l + [r])
        
        return decl
        
    default:
        return nil
    }
}

struct SwiftVariableDeclaration {
    var constant: Bool
    var attributes: [KnownAttribute]
    var modifiers: [SwiftDeclarationModifier]
    var kind: Kind

    enum Kind {
        case single(pattern: PatternBindingElement, Accessor?)
        case multiple(patterns: [PatternBindingElement])

        var patterns: [PatternBindingElement] {
            switch self {
            case .single(let pattern, _):
                return [pattern]
            case .multiple(let patterns):
                return patterns
            }
        }
    }

    enum Accessor {
        case computed(CompoundStatement)
        case getter(CompoundStatement, setter: Setter)
    }

    struct Setter {
        var valueIdentifier: String
        var body: CompoundStatement
    }
    
    struct PatternBindingElement {
        var name: String
        var type: SwiftType?
        var intention: IntentionProtocol?
        var initialization: Expression?
    }
}

enum SwiftDeclarationModifier: CustomStringConvertible {
    case mutating
    case `static`
    case optional
    case convenience
    case final
    case override
    case accessLevel(AccessLevel)
    case setterAccessLevel(AccessLevel)
    case ownership(Ownership)

    var description: String {
        switch self {
        case .mutating:
            return "mutating"
        case .static:
            return "static"

        case .optional:
            return "optional"

        case .convenience:
            return "convenience"

        case .final:
            return "final"

        case .override:
            return "override"

        case .accessLevel(let value):
            return value.rawValue

        case .setterAccessLevel(let value):
            return "\(value.rawValue)(set)"

        case .ownership(let value):
            return value.rawValue
        }
    }
}
