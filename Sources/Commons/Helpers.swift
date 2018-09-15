import SwiftAST
import SwiftRewriterLib
import MiniLexer

func makeType(from typeString: String) -> CompoundedMappingType {
    do {
        let incomplete = try SwiftClassInterfaceParser.parseDeclaration(from: typeString)
        let type = try incomplete.toCompoundedKnownType()
        
        return type
    } catch let error as LexerError {
        fatalError(
            """
            Found error while parsing class interface: \
            \(error.description(withOffsetsIn: typeString))
            """
        )
    } catch {
        fatalError(
            "Found error while parsing Calendar class interface: \(error)"
        )
    }
}
