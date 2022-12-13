extension GraphViz {
    /// Values for a `rankdir` graphviz attribute.
    public enum RankDir: String {
        /// Top-to-bottom
        case topToBottom = "TB"

        /// Bottom-to-top
        case bottomToTop = "BT"

        /// Left-to-right
        case leftToRight = "LR"

        /// Right-to-left
        case rightToLeft = "RL"
    }
}
