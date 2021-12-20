import GrammarModels
import GrammarModelBase

/// Protocol for sourcing code strings from
public protocol CodeSource: Source {
    func fetchSource() -> String
}
