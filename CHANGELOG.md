# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-04-05

### Added

- `Result.flatten()` static method to unwrap nested `Result<Result<T, E>, E>` into `Result<T, E>`

## [0.2.0] - 2026-04-04

### Added

- `Result.trySync()` for wrapping synchronous operations that may throw
- `unwrapOrElse()` for lazy default evaluation on error
- `expect()` for unwrapping with a custom error message
- `filter()` for conditional Ok-to-Err conversion based on a predicate
- `Result.zip()` for combining two Results into a single Result with a record

## [0.1.0] - 2026-04-03

### Added

- `Result<T, E>` sealed class with `Ok` and `Err` variants
- `when()` pattern matching for exhaustive case handling
- `map()` and `flatMap()` for chaining success transformations
- `mapErr()` for transforming error values
- `tryAsync()` static method to wrap async operations that may throw
- `collect()` static method to combine a list of Results into a Result of a list
- `unwrap()` and `unwrapOr()` for extracting values with or without defaults
