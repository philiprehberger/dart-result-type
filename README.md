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
  philiprehberger_result_type: ^0.1.0
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
| `map(U Function(T) f)` | Transform success value |
| `mapErr(F Function(E) f)` | Transform error value |
| `flatMap(Result<U,E> Function(T) f)` | Chain Result-producing operation |
| `when({ok, err})` | Exhaustive pattern match |
| `Result.tryAsync(fn, onError)` | Wrap async into Result |
| `Result.collect(results)` | Combine list of Results |

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

## License

MIT - see [LICENSE](LICENSE) for details.
