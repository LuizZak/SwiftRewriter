import struct Foundation.URL
import SwiftSyntax
import SwiftSyntaxParser

class ParserTransformer: TransformerType {
    /// File path to transform
    let filePath: URL

    private var targetClassName: String {
        filePath
            .deletingPathExtension()
            .lastPathComponent
    }

    init(filePath: URL) {
        self.filePath = filePath
    }

    private func load(_ fileIO: FileIOType) throws -> SourceFileSyntax {
        let source = try fileIO.readText(from: filePath)

        return try SyntaxParser.parse(source: source)
    }

    func validate(_ fileIO: FileIOType) throws {
        let file = try load(fileIO)
        guard !_isConverted(file) else {
            return
        }

        // Ensure we can locate all the necessary source code constructs
        for term in _ParserRewriter.SearchTerms.requiredTerms {
            if !file.contains(term) {
                throw Error.missingSourceConstruct(
                    description: "Could not locate necessary Parser source construct in \(filePath): \(term)"
                )
            }
        }
    }

    func transform(_ fileIO: FileIOType, formatter: SwiftFormatterTransformer?) throws -> SourceFileSyntax {
        try validate(fileIO)

        let file = try load(fileIO)
        guard !_isConverted(file) else {
            return file
        }

        let rewriter = _ParserRewriter(targetClassName: targetClassName)
        
        let transformed = rewriter.visit(file)

        return try formatter?.format(_stripPrevCtx(transformed)) ?? transformed
    }

    /// Strips 'var _prevctx' declarations and usages, which emit a warning when
    /// compiling later.
    private func _stripPrevCtx(_ file: SourceFileSyntax) throws -> SourceFileSyntax {
        let newFile =
            file
            .description
            .split(separator: "\n", omittingEmptySubsequences: false)
            .filter { !$0.contains("_prevctx") }
            .joined(separator: "\n")
        
        return try SyntaxParser.parse(source: newFile)
    }

    /// Attempt to verify that changes have not been done already on a given
    /// input file.
    private func _isConverted(_ file: SourceFileSyntax) -> Bool {
        guard let clsDecl = file.findRecursive(_ParserRewriter.SearchTerms.parserSubclass)?.as(ClassDeclSyntax.self) else {
            return false
        }
        
        return clsDecl.members.members
            .firstIndex(
                matching: _ParserRewriter.SearchTerms.stateSubclass
            ) != nil
    }

    enum Error: Swift.Error {
        case missingSourceConstruct(description: String)
    }
}

private class _ParserRewriter: SyntaxRewriter {
    /// Common syntax search terms that this parser rewriter uses to locate source
    /// constructs to modify.
    fileprivate enum SearchTerms {
        /// List of search terms that are required for a proper conversion.
        static let requiredTerms: [SyntaxSearchTerm] = [
            parserSubclass,
            _decisionToDFA,
            _sharedContextCache,
            getATN,
            _ATN,
            requiredInit,
        ]

        /// ```swift
        /// open class <any>: *Parser*
        /// ```
        static let parserSubclass: SyntaxSearchTerm = .classDecl(
            modifiers: [declModifier("open")],
            inheritance: [.contains("Parser")]
        )

        /// ```swift
        /// internal static var _decisionToDFA: [DFA]
        /// ```
        static let _decisionToDFA: SyntaxSearchTerm = .memberVarDecl(
            modifiers: [declModifier("internal"), declModifier("static")],
            identifier: "_decisionToDFA"
        )

        /// ```swift
        /// internal static var _sharedContextCache: [PredictionContextCache]
        /// ```
        static let _sharedContextCache: SyntaxSearchTerm = .memberVarDecl(
            modifiers: [declModifier("internal"), declModifier("static")],
            identifier: "_sharedContextCache"
        )

        /// ```swift
        /// override open func getATN() -> ATN
        /// ```
        static let getATN: SyntaxSearchTerm = .method(
            identifier: "getATN"
        )

        /// ```swift
        /// public static let _ATN: ATN
        /// ```
        static let _ATN: SyntaxSearchTerm = .memberVarDecl(
            modifiers: [declModifier("public"), declModifier("static")],
            identifier: "_ATN"
        )

        /// ```swift
        /// public override required init(_ input: TokenStream)
        /// ```
        static let requiredInit: SyntaxSearchTerm = .initializer(
            modifiers: [declModifier("override"), declModifier("public")],
            parameters: [.parameter(firstName: "_", secondName: "input", type: typeName("TokenStream"))]
        )

        /// ```swift
        /// public class State
        /// ```
        static let stateSubclass: SyntaxSearchTerm = .classDecl(
            modifiers: [declModifier("public")],
            identifier: "State",
            inheritance: []
        )
    }

    let targetClassName: String

    init(targetClassName: String) {
        self.targetClassName = targetClassName
    }

    override func visit(_ node: SourceFileSyntax) -> SourceFileSyntax {
        let node = super.visit(node).as(SourceFileSyntax.self) ?? node

        return node
    }

    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        let node = super.visit(node).as(ClassDeclSyntax.self) ?? node
        var membersList = node.members.members

        // Replace _decisionToDFA declaration with State class
        if let index = membersList.firstIndex(
            matching: SearchTerms._decisionToDFA
        ) {
            let leadingTrivia = membersList[
                membersList.index(membersList.startIndex, offsetBy: index)
            ].leadingTrivia

             membersList.replace(
                childAt: index,
                with: SourceGenerator
                    .stateClass()
                    .withLeadingTrivia(leadingTrivia ?? [])
                    .inMemberDeclListItem()
            )
        }

        // Pin-point _sharedContextCache to use as a marker for inserting the new
        // getter members
        if let index = membersList.firstIndex(
            matching: SearchTerms._sharedContextCache
        ) {
            // Note: Order of insertion is reversed

            // public var state: State
            membersList.insert(
                SourceGenerator
                    .stateVarDecl()
                    .withLeadingTrivia(.newlines(2))
                    .inMemberDeclListItem(),
                at: index + 1
            )

            // internal var _sharedContextCache
            membersList.replace(
                childAt: index,
                with: SourceGenerator
                    .sharedContextCacheGetter()
                    .withLeadingTrivia(.newlines(2))
                    .inMemberDeclListItem()
            )

            // internal var _decisionToDFA: [DFA]
            membersList.insert(
                SourceGenerator
                    .decisionToDFAGetter()
                    .withLeadingTrivia(.newlines(2))
                    .inMemberDeclListItem(),
                at: index
            )

            // public var _ATN: ATN
            membersList.insert(
                SourceGenerator
                    .atnGetter()
                    .withLeadingTrivia(.newlines(2))
                    .inMemberDeclListItem(),
                at: index
            )
        }

        // Replace 'getATN()' method
        if let index = membersList.firstIndex(matching: SearchTerms.getATN) {
            
            // override open func getATN() -> ATN
            membersList.replace(
                childAt: index,
                with: SourceGenerator
                    .getATNMethod()
                    .withLeadingTrivia(.newlines(2))
                    .inMemberDeclListItem()
            )
        }

        // Remove _ATN static variable
        if let index = membersList.firstIndex(matching: SearchTerms._ATN) {
            membersList.remove(childAt: index)
        }
        
        // Prepend new convenience init and replace current init
        if let index = membersList.firstIndex(matching: SearchTerms.requiredInit) {
            // public required init(_ input: CharStream, _ state: State)
            membersList.replace(
                childAt: index,
                with: SourceGenerator
                    .parserStatefulInitializer()
                    .withLeadingTrivia(.newlines(2))
                    .inMemberDeclListItem()
            )

            // public required convenience init(_ input: CharStream)
            membersList.insert(
                SourceGenerator
                    .parserConvenienceInit()
                    .withLeadingTrivia(.newlines(2))
                    .inMemberDeclListItem(),
                at: index
            )
        }

        return DeclSyntax(
            node.withMembers(
                node.members.withMembers(membersList)
            )
        )
    }
}

private extension MemberDeclListSyntax {
    mutating func insert(_ element: Element, at index: Int) {
        self = self.inserting(element, at: index)
    }

    mutating func remove(childAt index: Int) {
        self = self.removing(childAt: index)
    }

    mutating func replace(childAt index: Int, with element: Element) {
        self = self.replacing(childAt: index, with: element)
    }
}
