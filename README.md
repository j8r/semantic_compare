# SemanticCompare

Compare semver versions using semantic expressions

Most of the [npm's semver implementation](https://www.npmjs.com/package/semver) expressions are supported.

Only true semantic version numbers are allowed, with at least a major, minor and patch number (e.g. `1.2.3`)

## Installation

Add this block to your application's `shard.yml`:

```yaml
dependencies:
  semantic_compare:
    github: j8r/semantic_compare
```

## Usage

### Compare with simple expressions

```crystal
SemanticCompare.version "1.2.3", "1.2.0 - 1.4.0"
```

### Compare with 'or' `||` signs

```crystal
SemanticCompare.expression "1.2.3", ">=1.0.4 || <2.0.0 || ~1.2.1"
```

## License

Copyright (c) 2017 Julien Reichardt - ISC License
