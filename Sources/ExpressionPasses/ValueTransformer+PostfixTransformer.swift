import class Foundation.NSString
import SwiftAST
import SwiftRewriterLib

struct ValueTransformerWrapper: PostfixInvocationTransformer {
    let valueTransformer: ValueTransformer<PostfixExpression, Expression>
    let file: String
    let line: Int
    
    init(valueTransformer: ValueTransformer<PostfixExpression, Expression>,
         file: String = #file,
         line: Int = #line) {
        
        self.valueTransformer = valueTransformer
        self.file = (file as NSString).lastPathComponent
        self.line = line
    }
    
    func canApply(to postfix: PostfixExpression) -> Bool {
        return true
    }
    
    func attemptApply(on postfix: PostfixExpression) -> Expression? {
        return valueTransformer.transform(value: postfix)
    }
}

extension ValueTransformerWrapper: CustomStringConvertible {
    var description: String {
        return "\(valueTransformer) from \(file) at line \(line)"
    }
}
