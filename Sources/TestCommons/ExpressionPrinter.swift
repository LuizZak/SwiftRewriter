import SwiftAST
import WriterTargetOutput
import SwiftSyntaxSupport

public enum ExpressionPrinter {
    public static func print(expression: Expression) {
        let string = toString(expression: expression)
        
        Swift.print(string)
    }
    
    public static func toString(expression: Expression) -> String {
        let writer = SwiftSyntaxProducer(settings: .default)
        
        return writer.generateStatement(.expression(expression)).description
    }
}
