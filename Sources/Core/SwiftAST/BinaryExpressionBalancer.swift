/// Balances nested binary expressions based on operator precedence.
public class BinaryExpressionBalancer {
    public init() {

    }

    /// Balances a given binary expression tree such that operators in that tree
    /// are ordered based on their precedence.
    ///
    /// - note: Binary tree rotations have a left rotation bias for cases where
    /// either left or right rotations would produce valid results.
    public func balance(_ exp: BinaryExpression) -> BinaryExpression {
        var result = exp

        var didMutate: Bool
        repeat {
            didMutate = false

            result = descend(result, didMutate: &didMutate)
        } while didMutate

        return result
    }

    func descend(_ binary: BinaryExpression, didMutate: inout Bool) -> BinaryExpression {
        guard !didMutate else {
            return binary
        }

        switch rotateOrder(for: binary) {
        case .left:
            didMutate = true
            return rotateLeft(binary)
        
        case .right:
            didMutate = true
            return rotateRight(binary)

        case .none:
            if let left = binary.lhs.asBinary {
                binary.lhs = descend(left, didMutate: &didMutate)
            }
            if !didMutate, let right = binary.rhs.asBinary {
                binary.rhs = descend(right, didMutate: &didMutate)
            }

            return binary
        }
    }

    private func rotateOrder(for binary: BinaryExpression) -> RotationOrder {
        if let left = binary.lhs.asBinary, shouldRotateRight(binary, left: left) {
            return .right
        }
        if let right = binary.rhs.asBinary, shouldRotateLeft(binary, right: right) {
            return .left
        }

        return .none
    }

    /// Rotates a binary expression from the form `(a lhs (b rhs c))` to the form
    /// `((a lhs b) rhs c)`.
    ///
    /// If `binary` does not contain a binary expression on the right, nothing
    /// is done and a copy of `binary` is returned, instead.
    private func rotateLeft(_ binary: BinaryExpression) -> BinaryExpression {
        if let right = binary.rhs.asBinary {
            return rotateLeft(root: binary, right)
        }

        return binary.copy()
    }

    /// Rotates a binary expression from the form `((a lhs b) rhs c)` to the form
    /// `(a lhs (b rhs c))`.
    ///
    /// If `binary` does not contain a binary expression on the left, nothing
    /// is done and a copy of `binary` is returned, instead.
    private func rotateRight(_ binary: BinaryExpression) -> BinaryExpression {
        if let left = binary.lhs.asBinary {
            return rotateRight(left, root: binary)
        }

        return binary.copy()
    }

    /// Rotates a binary expression from the form `(a lhs (b rhs c))` to the form
    /// `((a lhs b) rhs c)`.
    ///
    /// `right` is assumed to be `root.rhs`.
    private func rotateLeft(root: BinaryExpression, _ right: BinaryExpression) -> BinaryExpression {
        assert(root.rhs === right)

        let a = root.lhs.copy()
        let lhs = root.op
        let b = right.lhs.copy()
        let rhs = right.op
        let c = right.rhs.copy()

        return a.binary(op: lhs, rhs: b).binary(op: rhs, rhs: c)
    }

    /// Rotates a binary expression from the form `((a lhs b) rhs c)` to the form
    /// `(a lhs (b rhs c))`.
    ///
    /// `left` is assumed to be `root.lhs`.
    private func rotateRight(_ left: BinaryExpression, root: BinaryExpression) -> BinaryExpression {
        assert(root.lhs === left)

        let a = left.lhs.copy()
        let lhs = left.op
        let b = left.rhs.copy()
        let rhs = root.op
        let c = root.rhs.copy()

        return a.binary(op: lhs, rhs: b.binary(op: rhs, rhs: c))
    }

    private func shouldRotateRight(_ root: BinaryExpression, left: BinaryExpression) -> Bool {
        return root.op.precedence(asInfix: true) < left.op.precedence(asInfix: true)
    }

    private func shouldRotateLeft(_ root: BinaryExpression, right: BinaryExpression) -> Bool {
        return root.op.precedence(asInfix: true) < right.op.precedence(asInfix: true)
    }

    /// Specifies the rotation order required for a binary expression in order
    /// to reorder relative to another nested binary expression such that their
    /// operators are put in the appropriate order.
    private enum RotationOrder {
        case left
        case none
        case right
    }
}
