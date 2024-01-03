/// A type that represents either success ([Ok]) or failure ([Err]).
///
/// Use `Result` instead of exceptions for operations that can fail:
/// ```dart
/// Result<int, String> divide(int a, int b) {
///   if (b == 0) return Result.err('Division by zero');
///   return Result.ok(a ~/ b);
/// }
/// ```
sealed class Result<T, E> {
  const Result._();

  /// Create a success result.
  const factory Result.ok(T value) = Ok<T, E>;

  /// Create a failure result.
  const factory Result.err(E error) = Err<T, E>;

  /// Whether this is an [Ok] result.
  bool get isOk;

  /// Whether this is an [Err] result.
  bool get isErr;

  /// The success value, or `null` if this is [Err].
  T? get okOrNull;

  /// The error value, or `null` if this is [Ok].
  E? get errOrNull;

  /// Unwrap the success value, or throw a [StateError] if this is [Err].
  T unwrap();

  /// Unwrap the success value, or return [defaultValue] if this is [Err].
  T unwrapOr(T defaultValue);

  /// Transform the success value.
  Result<U, E> map<U>(U Function(T) f);

  /// Transform the error value.
  Result<T, F> mapErr<F>(F Function(E) f);

  /// Chain another Result-producing operation.
  Result<U, E> flatMap<U>(Result<U, E> Function(T) f);

  /// Pattern match on the result.
  R when<R>(
      {required R Function(T value) ok, required R Function(E error) err});

  /// Wrap an async operation that may throw into a Result.
  static Future<Result<T, E>> tryAsync<T, E>(
    Future<T> Function() fn,
    E Function(Object error, StackTrace stack) onError,
  ) async {
    try {
      return Result.ok(await fn());
    } catch (e, s) {
      return Result.err(onError(e, s));
    }
  }

  /// Collect a list of Results into a Result of a list.
  ///
  /// Returns the first [Err] if any, otherwise returns [Ok] with all values.
  static Result<List<T>, E> collect<T, E>(List<Result<T, E>> results) {
    final values = <T>[];
    for (final result in results) {
      switch (result) {
        case Ok(:final value):
          values.add(value);
        case Err(:final error):
          return Result.err(error);
      }
    }
    return Result.ok(values);
  }
}

/// A successful result containing a [value].
final class Ok<T, E> extends Result<T, E> {
  /// The success value.
  final T value;

  /// Create an Ok result.
  const Ok(this.value) : super._();

  @override
  bool get isOk => true;

  @override
  bool get isErr => false;

  @override
  T? get okOrNull => value;

  @override
  E? get errOrNull => null;

  @override
  T unwrap() => value;

  @override
  T unwrapOr(T defaultValue) => value;

  @override
  Result<U, E> map<U>(U Function(T) f) => Result.ok(f(value));

  @override
  Result<T, F> mapErr<F>(F Function(E) f) => Result.ok(value);

  @override
  Result<U, E> flatMap<U>(Result<U, E> Function(T) f) => f(value);

  @override
  R when<R>(
          {required R Function(T value) ok,
          required R Function(E error) err}) =>
      ok(value);

  @override
  bool operator ==(Object other) => other is Ok<T, E> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Ok($value)';
}

/// A failure result containing an [error].
final class Err<T, E> extends Result<T, E> {
  /// The error value.
  final E error;

  /// Create an Err result.
  const Err(this.error) : super._();

  @override
  bool get isOk => false;

  @override
  bool get isErr => true;

  @override
  T? get okOrNull => null;

  @override
  E? get errOrNull => error;

  @override
  T unwrap() => throw StateError('Called unwrap() on Err: $error');

  @override
  T unwrapOr(T defaultValue) => defaultValue;

  @override
  Result<U, E> map<U>(U Function(T) f) => Result.err(error);

  @override
  Result<T, F> mapErr<F>(F Function(E) f) => Result.err(f(error));

  @override
  Result<U, E> flatMap<U>(Result<U, E> Function(T) f) => Result.err(error);

  @override
  R when<R>(
          {required R Function(T value) ok,
          required R Function(E error) err}) =>
      err(error);

  @override
  bool operator ==(Object other) =>
      other is Err<T, E> && other.error == error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Err($error)';
}
