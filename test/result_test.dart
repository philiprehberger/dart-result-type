import 'package:philiprehberger_result_type/philiprehberger_result_type.dart';
import 'package:test/test.dart';

void main() {
  group('Ok', () {
    test('isOk returns true', () {
      expect(Result<int, String>.ok(42).isOk, isTrue);
    });

    test('isErr returns false', () {
      expect(Result<int, String>.ok(42).isErr, isFalse);
    });

    test('okOrNull returns value', () {
      expect(Result<int, String>.ok(42).okOrNull, equals(42));
    });

    test('errOrNull returns null', () {
      expect(Result<int, String>.ok(42).errOrNull, isNull);
    });

    test('unwrap returns value', () {
      expect(Result<int, String>.ok(42).unwrap(), equals(42));
    });

    test('unwrapOr returns value', () {
      expect(Result<int, String>.ok(42).unwrapOr(0), equals(42));
    });

    test('map transforms value', () {
      final result = Result<int, String>.ok(2).map((v) => v * 3);
      expect(result.unwrap(), equals(6));
    });

    test('mapErr is no-op', () {
      final result = Result<int, String>.ok(42).mapErr((e) => 0);
      expect(result.unwrap(), equals(42));
    });

    test('flatMap chains results', () {
      final result =
          Result<int, String>.ok(10).flatMap((v) => Result.ok(v + 5));
      expect(result.unwrap(), equals(15));
    });

    test('when calls ok branch', () {
      final msg = Result<int, String>.ok(42).when(
        ok: (v) => 'got $v',
        err: (e) => 'error $e',
      );
      expect(msg, equals('got 42'));
    });

    test('equality', () {
      expect(Result<int, String>.ok(1), equals(Result<int, String>.ok(1)));
      expect(
          Result<int, String>.ok(1), isNot(equals(Result<int, String>.ok(2))));
    });

    test('toString', () {
      expect(Result<int, String>.ok(42).toString(), equals('Ok(42)'));
    });
  });

  group('Err', () {
    test('isOk returns false', () {
      expect(Result<int, String>.err('fail').isOk, isFalse);
    });

    test('isErr returns true', () {
      expect(Result<int, String>.err('fail').isErr, isTrue);
    });

    test('okOrNull returns null', () {
      expect(Result<int, String>.err('fail').okOrNull, isNull);
    });

    test('errOrNull returns error', () {
      expect(Result<int, String>.err('fail').errOrNull, equals('fail'));
    });

    test('unwrap throws StateError', () {
      expect(
          () => Result<int, String>.err('fail').unwrap(), throwsStateError);
    });

    test('unwrapOr returns default', () {
      expect(Result<int, String>.err('fail').unwrapOr(0), equals(0));
    });

    test('map is no-op on Err', () {
      final result = Result<int, String>.err('fail').map((v) => v * 2);
      expect(result.isErr, isTrue);
    });

    test('mapErr transforms error', () {
      final result =
          Result<int, String>.err('fail').mapErr((e) => e.length);
      expect(result.errOrNull, equals(4));
    });

    test('flatMap is no-op on Err', () {
      final result =
          Result<int, String>.err('fail').flatMap((v) => Result.ok(v + 1));
      expect(result.isErr, isTrue);
    });

    test('when calls err branch', () {
      final msg = Result<int, String>.err('fail').when(
        ok: (v) => 'got $v',
        err: (e) => 'error: $e',
      );
      expect(msg, equals('error: fail'));
    });

    test('equality', () {
      expect(Result<int, String>.err('a'),
          equals(Result<int, String>.err('a')));
    });

    test('toString', () {
      expect(
          Result<int, String>.err('fail').toString(), equals('Err(fail)'));
    });
  });

  group('Result.tryAsync', () {
    test('wraps successful async', () async {
      final result = await Result.tryAsync<int, String>(
        () async => 42,
        (e, s) => 'error: $e',
      );
      expect(result.unwrap(), equals(42));
    });

    test('wraps failed async', () async {
      final result = await Result.tryAsync<int, String>(
        () async => throw Exception('boom'),
        (e, s) => 'caught: $e',
      );
      expect(result.isErr, isTrue);
      expect(result.errOrNull, contains('caught'));
    });
  });

  group('Result.collect', () {
    test('collects all Ok values', () {
      final results = [
        Result<int, String>.ok(1),
        Result.ok(2),
        Result.ok(3)
      ];
      final collected = Result.collect(results);
      expect(collected.unwrap(), equals([1, 2, 3]));
    });

    test('returns first Err', () {
      final results = [
        Result<int, String>.ok(1),
        Result.err('bad'),
        Result.ok(3)
      ];
      final collected = Result.collect(results);
      expect(collected.isErr, isTrue);
      expect(collected.errOrNull, equals('bad'));
    });

    test('empty list returns Ok([])', () {
      final collected = Result.collect<int, String>([]);
      expect(collected.unwrap(), equals(<int>[]));
    });
  });
}
