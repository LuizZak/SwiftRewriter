import Antlr4
import ObjcParserAntlr

class ObjcPreprocessorListener: ObjectiveCPreprocessorParserBaseListener {
    var preprocessorDirectiveIntervals: [Range<Int>] = []
    
    override func enterText(_ ctx: ObjectiveCPreprocessorParser.TextContext) {
        if ctx.directive() != nil {
            guard let start = ctx.start?.getStartIndex(), let stop = ctx.stop?.getStopIndex() else {
                return
            }
            
            preprocessorDirectiveIntervals.append(start..<stop + 1)
        }
    }
    
    public static func walk(_ tree: ParseTree) -> [Range<Int>] {
        let listener = ObjcPreprocessorListener()
        
        let walker = ParseTreeWalker()
        try? walker.walk(listener, tree)
        
        return listener.preprocessorDirectiveIntervals
    }
}
