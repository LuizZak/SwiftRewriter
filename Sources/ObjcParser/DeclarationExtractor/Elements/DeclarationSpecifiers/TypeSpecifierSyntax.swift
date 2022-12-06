// Objective-C type specifiers derived from 'Inside Mac OS X: The Objective-C Programming Language',
// by Apple Computer, Inc. February 2003
// reference: http://andrewd.ces.clemson.edu/courses/cpsc102/notes/ObjC.pdf

import ObjcParserAntlr

/// Type specifier syntax for declarations.
public enum TypeSpecifierSyntax: Hashable, Codable {
    case scalar(ScalarTypeSpecifierSyntax)
    case typeIdentifier(TypeIdentifierSyntax)
    case genericTypeIdentifier(GenericTypeSpecifierSyntax)
    case id(ProtocolReferenceListSyntax?)
    case className(TypeIdentifierSyntax, ProtocolReferenceListSyntax?)
    case structOrUnion(StructOrUnionSpecifierSyntax)
    case `enum`(EnumSpecifierSyntax)
    /// __typeof__(<exp>) type specifier.
    case typeof(expression: ExpressionSyntax)
}

extension TypeSpecifierSyntax: DeclarationSyntaxElementType {
    public var children: [DeclarationSyntaxElementType] {
        switch self {
        case .scalar(let value):
            return toChildrenList(value)
        case .typeIdentifier(let value):
            return toChildrenList(value)
        case .genericTypeIdentifier(let value):
            return toChildrenList(value)
        case .id(let value):
            return toChildrenList(value)
        case .className(let identifier, let value):
            return toChildrenList(identifier, value)
        case .structOrUnion(let value):
            return toChildrenList(value)
        case .enum(let value):
            return toChildrenList(value)
        case .typeof(let value):
            return toChildrenList(value)
        }
    }
}
extension TypeSpecifierSyntax: CustomStringConvertible {
    public var description: String {
        switch self {
        case .scalar(let value):
            return "\(value)"
        case .typeIdentifier(let value):
            return "\(value)"
        case .genericTypeIdentifier(let value):
            return "\(value)"
        case .id(let protocols?):
            return "id\(protocols)"
        case .id(nil):
            return "id"
        case .className(let identifier, let protocols?):
            return "\(identifier)\(protocols)"
        case .className(let identifier, nil):
            return "\(identifier)"
        case .structOrUnion(let value):
            return "\(value)"
        case .enum(let value):
            return "\(value)"
        case .typeof(let value):
            return "\(value)"
        }
    }
}
