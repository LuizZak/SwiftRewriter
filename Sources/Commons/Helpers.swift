import SwiftAST
import MiniLexer

func makeType(from typeString: String, typeName: String) -> CompoundedMappingType {
    do {
//        let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: typeString)
        let result = _SwiftSyntaxTypeParser(source: typeString)
        let incomplete = result.parseTypes()[0]
        
        let type = try incomplete.toCompoundedKnownType()
        
        return type
    } catch let error as LexerError {
        fatalError(
            """
            Found error while parsing class interface '\(typeName)': \
            \(error.description(withOffsetsIn: typeString))
            """
        )
    } catch {
        fatalError(
            "Found error while parsing Calendar class interface: \(error)"
        )
    }
}
