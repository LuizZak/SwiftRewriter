import Antlr4
import Utils
import AntlrCommons
import JsParserAntlr
import GrammarModelBase
import JsGrammarModels

/// Listener that collects import declarations from a JavaScript syntax tree.
internal class JsImportDeclListener: JavaScriptParserBaseListener {
    var importDecls: [JsImportDecl] = []

    override func enterImportStatement(_ ctx: JavaScriptParser.ImportStatementContext) {
        guard let importFromBlock = ctx.importFromBlock() else { return }
        guard let pathNode = importFromBlock.importFrom()?.StringLiteral() ?? importFromBlock.StringLiteral() else { return }

        let path = JsParser.parseStringContents(pathNode)

        var symbols: [String] = []

        func inspectAlias(_ aliasName: JavaScriptParser.AliasNameContext) {
            if let identifierName = aliasName.identifierName(0) {
                symbols.append(identifierName.getText())
            }
        }

        // import defaultExport from "module-name";
        // or:
        // import defaultExport as alias from "module-name";
        if let aliasName = importFromBlock.importDefault()?.aliasName() {
            inspectAlias(aliasName)
        }

        // import * as name from "module-name"
        if importFromBlock.importNamespace()?.Multiply() != nil {
            symbols.append("*")
        }
        // import identifier as name from "module-name"
        else if let importNamespace = importFromBlock.importNamespace()?.identifierName(0) {
            symbols.append(importNamespace.getText())
        }

        // import { export1, export2 as alias2, /* … */ } from "module-name";
        if let moduleItems = importFromBlock.moduleItems() {
            for aliasName in moduleItems.aliasName() {
                inspectAlias(aliasName)
            }
        }

        let importDecl = JsImportDecl(
            symbols: symbols,
            path: path,
            isSystemImport: false
        )

        importDecls.append(importDecl)
    }
}
