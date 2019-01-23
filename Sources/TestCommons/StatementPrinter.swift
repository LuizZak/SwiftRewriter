import SwiftAST
import WriterTargetOutput
import SwiftSyntaxSupport

public enum StatementPrinter {
    public static func print(statement: Statement) {
        let string = toString(statement: statement)
        
        Swift.print(string)
    }
    
    public static func toString(statement: Statement) -> String {
        let writer = SwiftSyntaxProducer(settings: .default)
        
        return writer.generateStatement(statement).description
    }
}
