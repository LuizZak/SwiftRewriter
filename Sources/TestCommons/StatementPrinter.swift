import SwiftAST
import SwiftRewriterLib
import WriterTargetOutput

public enum StatementPrinter {
    public static func print(statement: Statement) {
        let string = toString(statement: statement)
        
        Swift.print(string)
    }
    
    public static func toString(statement: Statement) -> String {
        let target = StringRewriterOutput(settings: .defaults)
        
        let writer =
            StatementWriter(options: .default,
                            target: target,
                            typeMapper: DefaultTypeMapper(),
                            typeSystem: TypeSystem())
        
        writer.visitStatement(statement)
        
        return target.buffer
    }
}
