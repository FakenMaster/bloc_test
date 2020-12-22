extension ObjectX on Object {
  T next<T>(T nextFn(), T orElse()) {
    if (this == null) {
      return orElse?.call();
    }
    return nextFn?.call();
  }
}
