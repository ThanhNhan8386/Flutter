class Either<L, R> {
  final L? _left;
  final R? _right;

  const Either.left(L left)
      : _left = left,
        _right = null;

  const Either.right(R right)
      : _left = null,
        _right = right;

  bool get isLeft => _left != null;
  bool get isRight => _right != null;

  L get left => _left!;
  R get right => _right!;

  T fold<T>(T Function(L) leftFn, T Function(R) rightFn) {
    if (isLeft) {
      return leftFn(_left!);
    } else {
      return rightFn(_right!);
    }
  }
}
