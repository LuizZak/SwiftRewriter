// Based off of code found on ANTLR's repository.
//
// Files are distributed under MIT license:
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import Antlr4
import ObjcParserAntlr

/**
 * Created by ikochurkin on 28.07.2016.
 */
class ObjectiveCPreprocessor: ObjectiveCPreprocessorParserBaseVisitor<String> {
    typealias Parser = ObjectiveCPreprocessorParser
    
    private var _conditions: [Bool] = []
    private var _compilied = true
    private var _tokensStream: CommonTokenStream
    
    public var conditionalSymbols: [String: String] = [:]
    
    init(commonTokenStream: CommonTokenStream) {
        _conditions.append(true)
        _tokensStream = commonTokenStream
    }
    
    public override func visitObjectiveCDocument(_ ctx: Parser.ObjectiveCDocumentContext) -> String? {
        var result = ""
        
        for text in ctx.text() {
            result += visit(text) ?? ""
        }
        
        return result
    }
    
    public override func visitText(_ context: Parser.TextContext) -> String? {
        var result = context.getText()
        var directive = false
        if let direct = context.directive() {
            _compilied = visit(direct) == "true"
            directive = true
        }
        if !_compilied || directive {
            var sb = ""
            sb.reserveCapacity(result.count)
            
            for c in result {
                sb.append(c == "\r" || c == "\n" ? c : " ")
            }
            result = sb
        }
        
        return result
    }
    
    public override func visitPreprocessorImport(_ context: Parser.PreprocessorImportContext) -> String? {
        return isCompiledText().description
    }
    
    public override func visitPreprocessorConditional(_ context: Parser.PreprocessorConditionalContext) -> String? {
        if context.IF() != nil {
            let exprResult = context.preprocessor_expression()?.accept(self) == "true"
            _conditions.append(exprResult)
            return (exprResult && isCompiledText()).description
        } else if context.ELIF() != nil {
            _=_conditions.popLast()
            let exprResult = context.preprocessor_expression()?.accept(self) == "true"
            _conditions.append(exprResult)
            return (exprResult && isCompiledText()).description
        } else if context.ELSE() != nil {
            let val = _conditions.removeLast()
            _conditions.append(!val)
            return (!val ? isCompiledText() : false).description
        } else {
            _conditions.removeLast()
            return _conditions.last?.description
        }
    }
    
    public override func visitPreprocessorDef(_ context: Parser.PreprocessorDefContext) -> String? {
        let conditionalSymbolText = context.CONDITIONAL_SYMBOL()?.getText() ?? ""
        
        if context.IFDEF() != nil || context.IFNDEF() != nil {
            var condition = conditionalSymbols.keys.contains(conditionalSymbolText)
            if context.IFNDEF() != nil {
                condition = !condition
            }
            _conditions.append(condition)
            return (condition && isCompiledText()).description
        } else {
            if isCompiledText() {
                conditionalSymbols.removeValue(forKey: conditionalSymbolText)
            }
            return isCompiledText().description
        }
    }
    
    public override func visitPreprocessorPragma(_ context: Parser.PreprocessorPragmaContext) -> String? {
        return isCompiledText().description
    }
    
    public override func visitPreprocessorError(_ context: Parser.PreprocessorErrorContext) -> String? {
        return isCompiledText().description
    }
    
    public override func visitPreprocessorDefine(_ context: Parser.PreprocessorDefineContext) -> String? {
        if isCompiledText() {
            var str = ""
            
            str.append(context.directive_text()?.getText() ?? "\r\n")
            
            let directiveText = str.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if let cond = context.CONDITIONAL_SYMBOL()?.getText().replacingOccurrences(of: " ", with: "") {
                conditionalSymbols[cond] = directiveText
            }
        }
        
        return isCompiledText().description
    }
    
    public override func visitPreprocessorConstant(_ context: Parser.PreprocessorConstantContext) -> String? {
        if context.TRUE() != nil || context.FALSE() != nil {
            return (context.TRUE() != nil).description
        } else {
            return context.getText()
        }
    }
    
    override
    public func visitPreprocessorConditionalSymbol(_ context: Parser.PreprocessorConditionalSymbolContext) -> String? {
        guard let text = context.CONDITIONAL_SYMBOL()?.getText() else {
            return false.description
        }
        
        if let symbol = conditionalSymbols[text] {
            return symbol
        } else {
            return false.description
        }
    }
    
    public override func visitPreprocessorParenthesis(_ context: Parser.PreprocessorParenthesisContext) -> String? {
        return context.preprocessor_expression()?.accept(self)
    }
    
    public override func visitPreprocessorNot(_ context: Parser.PreprocessorNotContext) -> String? {
        guard let value = context.preprocessor_expression()?.accept(self) else {
            return false.description
        }
        
        return value == "true" ? "false" : "true"
    }
    
    public override func visitPreprocessorBinary(_ context: Parser.PreprocessorBinaryContext) -> String? {
        let expr1Result = context.preprocessor_expression(0)?.accept(self)
        let expr2Result = context.preprocessor_expression(1)?.accept(self)
        
        let op = context.op.getText()
        
        var result: Bool
        
        switch (op) {
        case "&&":
            result = expr1Result == "true" && expr2Result == "true"
        case "||":
            result = expr1Result == "true" || expr2Result == "true"
        case "==":
            result = expr1Result == expr2Result
        case "!=":
            result = expr1Result != expr2Result
        case "<", ">", "<=", ">=":
            if let x1 = Int(expr1Result ?? ""), let x2 = Int(expr2Result ?? "") {
                switch (op) {
                case "<":
                    result = x1 < x2
                case ">":
                    result = x1 > x2
                case "<=":
                    result = x1 <= x2
                case ">=":
                    result = x1 >= x2
                default:
                    break
                }
            }
            result = false
        default:
            result = true
        }
        return result.description
    }
    
    public override func visitPreprocessorDefined(_ context: Parser.PreprocessorDefinedContext) -> String? {
        guard let text = context.CONDITIONAL_SYMBOL()?.getText() else {
            return "false"
        }
        
        return conditionalSymbols.keys.contains(text).description
    }
    
    private func isCompiledText() -> Bool {
        return !_conditions.contains(false)
    }
}
