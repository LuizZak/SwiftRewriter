import SwiftAST

// MARK: - Statements

extension BreakStatement: ControlFlowGraphSyntaxNode { }
extension CatchBlock: ControlFlowGraphSyntaxNode { }
extension CompoundStatement: ControlFlowGraphSyntaxNode { }
extension ContinueStatement: ControlFlowGraphSyntaxNode { }
extension DeferStatement: ControlFlowGraphSyntaxNode { }
extension DoWhileStatement: ControlFlowGraphSyntaxNode { }
extension ExpressionsStatement: ControlFlowGraphSyntaxNode { }
extension FallthroughStatement: ControlFlowGraphSyntaxNode { }
extension ForStatement: ControlFlowGraphSyntaxNode { }
extension IfStatement: ControlFlowGraphSyntaxNode { }
extension ReturnStatement: ControlFlowGraphSyntaxNode { }
extension StatementVariableDeclaration: ControlFlowGraphSyntaxNode { }
extension SwitchCase: ControlFlowGraphSyntaxNode { }
extension SwitchDefaultCase: ControlFlowGraphSyntaxNode { }
extension SwitchStatement: ControlFlowGraphSyntaxNode { }
extension ThrowStatement: ControlFlowGraphSyntaxNode { }
extension UnknownStatement: ControlFlowGraphSyntaxNode { }
extension WhileStatement: ControlFlowGraphSyntaxNode { }

// MARK: - Expressions

extension Expression: ControlFlowGraphSyntaxNode { } // Any expression can be a part of a CFG.
