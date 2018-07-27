prefix operator ~~

extension KeyPath {
    public static prefix func ~~ (lhs: KeyPath) -> (Root) -> Value {
        return { v in
            v[keyPath: lhs]
        }
    }
}
