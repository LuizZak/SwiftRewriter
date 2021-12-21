import Antlr4
import AntlrCommons
import JsParserAntlr
import JsGrammarModels
import GrammarModelBase

internal class JsParserListener: JavaScriptParserBaseListener {
    let rootNode: JsGlobalContextNode = JsGlobalContextNode()

    override func enterEveryRule(_ ctx: ParserRuleContext) throws {
        try super.enterEveryRule(ctx)

        // print("\(type(of: ctx))")
    }
}
