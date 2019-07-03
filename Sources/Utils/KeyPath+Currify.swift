prefix operator ~~

extension KeyPath {
    @inlinable
    public static prefix func ~~ (lhs: KeyPath) -> (Root) -> Value {
        { v in
            v[keyPath: lhs]
        }
    }
}
