import SwiftSyntax

/// Terms for locating elements in a `Syntax` tree.
enum SyntaxSearchTerm: CustomStringConvertible {
    case memberVarDecl(modifiers: [DeclModifierSyntax]? = nil, identifier: StringMatcher? = nil, type: TypeSyntax? = nil)
    case initializer(modifiers: [DeclModifierSyntax]? = nil, parameters: [Self]? = nil)
    case method(modifiers: [DeclModifierSyntax]? = nil, identifier: StringMatcher?, parameters: [Self]? = nil)
    case parameter(firstName: StringMatcher? = nil, secondName: StringMatcher? = nil, type: TypeSyntax? = nil)
    case classDecl(modifiers: [DeclModifierSyntax]? = nil, identifier: StringMatcher? = nil, inheritance: [StringMatcher]? = nil)

    var description: String {
        switch self {
        case .memberVarDecl(let modifiers, let identifier, let type):
            return "\(toString(modifiers))var \(identifier ?? "<any>")\(toString(annotation: type))"

        case .initializer(let modifiers, let parameters):
            return "\(toString(modifiers))init\(toString(parameters: parameters))"

        case .method(let modifiers, let identifier, let parameters):
            return "\(toString(modifiers))func \(identifier ?? "<any>")\(toString(parameters: parameters))"

        case .parameter(let firstName, let secondName, let type):
            return "\(firstName ?? "<any>") \(secondName ?? "<any>")\(toString(annotation: type))"

        case .classDecl(let modifiers, let identifier, let inheritance):
            return "\(toString(modifiers))class \(identifier ?? "<any>")\(toString(inheritance: inheritance))"
        }
    }

    func firstIndexMatching<C: SyntaxCollection>(in syntaxCollection: C) -> Int? where C.Element: SyntaxProtocol {
        syntaxCollection.firstIndex(matching: self)
    }

    /// Returns `true` if this search term matches a given syntax object.
    func matches(_ syntax: SyntaxProtocol) -> Bool {
        let syntax = Syntax(syntax)

        switch self {
        case .initializer(let modifiers, let parameters):
            // Implicit unwrap member decl list items
            if let syntax = syntax.as(MemberDeclListItemSyntax.self) {
                return self.matches(syntax.decl)
            }

            guard let syntax = syntax.as(InitializerDeclSyntax.self) else {
                return false
            }

            guard modifiersMatch(syntax.modifiers, expected: modifiers) else {
                return false
            }
            guard parametersMatch(syntax.parameters.parameterList, expected: parameters) else {
                return false
            }

            return true

        case .method(let modifiers, let identifier, let parameters):
            // Implicit unwrap member decl list items
            if let syntax = syntax.as(MemberDeclListItemSyntax.self) {
                return self.matches(syntax.decl)
            }

            guard let syntax = syntax.as(FunctionDeclSyntax.self) else {
                return false
            }

            guard tokenMatches(syntax.identifier, expected: identifier) else {
                return false
            }
            guard modifiersMatch(syntax.modifiers, expected: modifiers) else {
                return false
            }
            guard parametersMatch(syntax.signature.input.parameterList, expected: parameters) else {
                return false
            }

            return true

        case .memberVarDecl(let modifiers, let identifier, let type):
            // Implicit unwrap member decl list items
            if let syntax = syntax.as(MemberDeclListItemSyntax.self) {
                return self.matches(syntax.decl)
            }

            guard let varDecl = syntax.as(VariableDeclSyntax.self) else {
                return false
            }

            guard modifiersMatch(varDecl.modifiers, expected: modifiers) else {
                return false
            }

            if let identifier {
                guard varDecl.bindings.count == 1, let binding = varDecl.bindings.first else {
                    return false
                }
                guard let identifierSyntax = binding.pattern.as(IdentifierPatternSyntax.self) else {
                    return false
                }

                if !identifier.matches(identifierSyntax.identifier.text) {
                    return false
                }

                return typesMatch(binding.typeAnnotation?.type, expected: type)
            }

            return true

        case .parameter(let firstName, let secondName, let type):
            guard let syntax = syntax.as(FunctionParameterSyntax.self) else {
                return false
            }

            guard
                tokenMatches(syntax.firstName, expected: firstName),
                tokenMatches(syntax.secondName, expected: secondName),
                typesMatch(syntax.type, expected: type)
            else {
                return false
            }

            return true

        case .classDecl(let modifiers, let identifier, let inheritance):
            // Implicit unwrap member decl list items
            if let syntax = syntax.as(MemberDeclListItemSyntax.self) {
                return self.matches(syntax.decl)
            }

            guard let classDecl = syntax.as(ClassDeclSyntax.self) else {
                return false
            }

            guard modifiersMatch(classDecl.modifiers, expected: modifiers) else {
                return false
            }
            guard tokenMatches(classDecl.identifier, expected: identifier) else {
                return false
            }
            guard inheritancesMatch(classDecl.inheritanceClause, expected: inheritance) else {
                return false
            }

            return true
        }
    }
}

extension SyntaxProtocol {
    /// Returns `true` if any child syntax node within this syntax object matches
    /// the given search term.
    ///
    /// Lookup is done in breadth-first order.
    func contains(_ search: SyntaxSearchTerm) -> Bool {
        findRecursive(search) != nil
    }

    /// Returns the first syntax child that matches a given search term.
    ///
    /// Lookup is done in breadth-first order.
    func findRecursive(_ search: SyntaxSearchTerm) -> Syntax? {
        var queue: [SyntaxProtocol] = [self]

        while !queue.isEmpty {
            let next = queue.removeFirst()

            if search.matches(next) {
                return Syntax(next)
            }

            for child in next.children {
                queue.append(child)
            }
        }

        return nil
    }
}

extension SyntaxCollection {
    func firstIndex(matching search: SyntaxSearchTerm) -> Int? where Element: SyntaxProtocol {
        for (i, syntax) in self.enumerated() {
            if search.matches(syntax) {
                return i
            }
        }

        return nil
    }
}

private func tokenMatches(_ token: TokenSyntax?, expected: StringMatcher?) -> Bool {
    guard let expected else { return true }
    guard let token else { return false }

    return expected.matches(token.text)
}

private func tokenMatches(_ token: TokenSyntax?, expected: String?) -> Bool {
    guard let expected else { return true }
    guard let token else { return false }

    return token.text == expected
}

private func typesMatch(_ actual: TypeSyntax?, expected: TypeSyntax?) -> Bool {
    guard let expected else { return true }
    guard let actual else { return false }

    return zip(actual.tokens, expected.tokens).allSatisfy {
        $0.text == $1.text
    }
}

private func modifiersMatch(_ actual: DeclModifierSyntax?, expected: DeclModifierSyntax?) -> Bool {
    guard let expected else { return true }
    guard let actual else { return false }

    return zip(actual.tokens, expected.tokens).allSatisfy {
        $0.text == $1.text
    }
}

private func modifiersMatch(_ actual: ModifierListSyntax?, expected: [DeclModifierSyntax]?) -> Bool {
    guard let expected else {
        return true
    }
    guard let actual else {
        return expected.isEmpty
    }

    if actual.count != expected.count {
        return false
    }

    for (mod, exp) in zip(actual, expected) {
        if !modifiersMatch(mod, expected: exp) {
            return false
        }
    }

    return true
}

private func parametersMatch(_ actual: FunctionParameterListSyntax?, expected: [SyntaxSearchTerm]?) -> Bool {
    guard let expected else {
        return true
    }
    guard let actual else {
        return expected.isEmpty
    }

    if actual.count != expected.count {
        return false
    }
    
    for (p, search) in zip(actual, expected) {
        if !search.matches(p.asSyntax) {
            return false
        }
    }

    return true
}

private func inheritancesMatch(_ actual: TypeInheritanceClauseSyntax?, expected: [StringMatcher]?) -> Bool {
    guard let expected else {
        return true
    }
    guard let actual else {
        return expected.isEmpty
    }
    
    if actual.inheritedTypeCollection.count != expected.count {
        return false
    }
    
    for (inheritance, exp) in zip(actual.inheritedTypeCollection, expected) {
        if !exp.matches(inheritance.typeName.description) {
            return false
        }
    }

    return true
}

// MARK: - Stringify

private func toString(_ modifiers: [DeclModifierSyntax]?) -> String {
    guard let modifiers else {
        return ""
    }

    return modifiers.map {
        $0.withoutTrivia().description
    }.joined(separator: " ") + " "
}

private func toString(annotation type: TypeSyntax?) -> String {
    guard let type else {
        return ""
    }

    return ": \(type.withoutTrivia().description)"
}

private func toString(parameters: [SyntaxSearchTerm]?) -> String {
    guard let parameters else {
        return "(...)"
    }

    return "(\(parameters.map { $0.description }.joined(separator: ", ")))"
}

private func toString(inheritance: [Any]?) -> String {
    guard let inheritance else {
        return ""
    }

    return ": \(inheritance.map { String(describing: $0) }.joined(separator: ", "))"
}
