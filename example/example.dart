import 'package:philiprehberger_result_type/philiprehberger_result_type.dart';

Result<int, String> divide(int a, int b) {
  if (b == 0) return Result.err('Division by zero');
  return Result.ok(a ~/ b);
}

void main() async {
  // Basic usage
  final result = divide(10, 2);
  print(result); // Ok(5)

  // Pattern matching
  final message = result.when(
    ok: (value) => 'Result: $value',
    err: (error) => 'Error: $error',
  );
  print(message); // Result: 5

  // Map
  final doubled = result.map((v) => v * 2);
  print(doubled); // Ok(10)

  // Error handling
  final bad = divide(10, 0);
  print(bad.isErr); // true
  print(bad.unwrapOr(-1)); // -1

  // tryAsync
  final fetched = await Result.tryAsync(
    () async => 42,
    (e, s) => 'Failed: $e',
  );
  print(fetched); // Ok(42)

  // collect
  final results = [Result<int, String>.ok(1), Result.ok(2), Result.ok(3)];
  final collected = Result.collect(results);
  print(collected); // Ok([1, 2, 3])
}
