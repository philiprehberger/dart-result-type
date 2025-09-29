# philiprehberger_result_type

[![pub package](https://img.shields.io/pub/v/philiprehberger_result_type.svg)](https://pub.dev/packages/philiprehberger_result_type)
[![CI](https://github.com/philiprehberger/dart-result-type/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/dart-result-type/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

Rust-style Result type for type-safe error handling with pattern matching.

## Requirements

- Dart SDK ^3.6.0

## Installation

```yaml
dependencies:
  philiprehberger_result_type: ^0.3.0
```

```bash
dart pub get
```

## Usage

```dart
import 'package:philiprehberger_result_type/philiprehberger_result_type.dart';

Result<int, String> divide(int a, int b) {
  if (b == 0) return Result.err('Division by zero');
  return Result.ok(a ~/ b);
}
```

### Pattern Matching

```dart
final result = divide(10, 2);

final message = result.when(
  ok: (value) => 'Result: $value',
  err: (error) => 'Error: $error',
);
print(message); // Result: 5
```

### Transformations

```dart
// Map success values
final doubled = Result<int, String>.ok(5).map((v) => v * 2);
print(doubled); // Ok(10)

// Chain operations
final chained = Result<int, String>.ok(10)
    .flatMap((v) => v > 0 ? Result.ok(v) : Result.err('must be positive'));

// Transform errors
final mapped = Result<int, String>.err('not found')
    .mapErr((e) => 'Error: $e');
```

### Async Error Handling

```dart
final result = await Result.tryAsync(
  () async => fetchDataFromApi(),
  (error, stack) => 'Request failed: $error',
);
```

### Collecting Results

```dart
final results = [Result<int, String>.ok(1), Result.ok(2), Result.ok(3)];
final collected = Result.collect(results);
print(collected); // Ok([1, 2, 3])

final mixed = [Result<int, String>.ok(1), Result.err('bad')];
final failed = Result.collect(mixed);
print(failed); // Err(bad)
```

### Unwrapping

```dart
final ok = Result<int, String>.ok(42);
print(ok.unwrap());      // 42
print(ok.unwrapOr(0));   // 42

final err = Result<int, String>.err('fail');
print(err.unwrapOr(0));  // 0
// err.unwrap();          // throws StateError
```

### Unwrap with Lazy Default

```dart
final result = Err<int, String>('missing');
final value = result.unwrapOrElse((e) => e.length);
print(value); // 7
```

### Expect

```dart
final result = Result<int, String>.ok(42);
print(result.expect('value must exist')); // 42

// On Err, throws StateError with custom message:
// Result<int, String>.err('fail').expect('value must exist');
```

### Sync Error Handling

```dart
final result = Result.trySync(
  () => int.parse('42'),
  (error) => 'parse failed: $error',
);
print(result); // Ok(42)
```

### Filtering

```dart
final result = Result<int, String>.ok(5)
    .filter((v) => v > 0, (v) => 'expected positive, got $v');
print(result); // Ok(5)

final filtered = Result<int, String>.ok(-1)
    .filter((v) => v > 0, (v) => 'expected positive, got $v');
print(filtered); // Err(expected positive, got -1)
```

### Flattening Nested Results

```dart
final nested = Result<Result<int, String>, String>.ok(Result.ok(42));
final flat = Result.flatten(nested);
print(flat); // Ok(42)

final nestedErr = Result<Result<int, String>, String>.err('outer error');
final flatErr = Result.flatten(nestedErr);
print(flatErr); // Err(outer error)
```

### Zipping Results

```dart
final a = Result<int, String>.ok(1);
final b = Result<int, String>.ok(2);
final zipped = Result.zip(a, b);
print(zipped); // Ok((1, 2))
```

## API

### Result\<T, E\>

| Member | Description |
|---|---|
| `Result.ok(T value)` | Create a success result |
| `Result.err(E error)` | Create a failure result |
| `isOk` | Whether this is an Ok result |
| `isErr` | Whether this is an Err result |
| `okOrNull` | Success value or null |
| `errOrNull` | Error value or null |
| `unwrap()` | Get value or throw StateError |
| `unwrapOr(T default)` | Get value or return default |
| `unwrapOrElse(T Function(E) fn)` | Get value or compute default from error |
| `expect(String message)` | Get value or throw StateError with message |
| `map(U Function(T) f)` | Transform success value |
| `mapErr(F Function(E) f)` | Transform error value |
| `flatMap(Result<U,E> Function(T) f)` | Chain Result-producing operation |
| `filter(predicate, orElse)` | Keep Ok if predicate passes, else convert to Err |
| `when({ok, err})` | Exhaustive pattern match |
| `Result.trySync(fn, onError)` | Wrap sync operation into Result |
| `Result.tryAsync(fn, onError)` | Wrap async operation into Result |
| `Result.collect(results)` | Combine list of Results |
| `Result.flatten(nested)` | Unwrap nested `Result<Result<T,E>,E>` into `Result<T,E>` |
| `Result.zip(a, b)` | Combine two Results into a record |

### Ok\<T, E\>

Success variant. Holds a `value` of type `T`. All transformation methods operate on the value.

### Err\<T, E\>

Failure variant. Holds an `error` of type `E`. Transformation methods like `map` and `flatMap` pass through the error unchanged.

## Development

```bash
dart pub get
dart analyze --fatal-infos
dart test
```

## Support

File issues on [GitHub](https://github.com/philiprehberger/dart-result-type/issues).

## License

MIT - see [LICENSE](LICENSE) for details.
