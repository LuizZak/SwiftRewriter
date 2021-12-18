import GrammarModels

/// Protocol for sourcing code strings from
public protocol CodeSource: Source {
    func fetchSource() -> String
}
