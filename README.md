# SemanticCompare

Compare semver versions using semantic expressions.

Most of the [npm's semver implementation](https://www.npmjs.com/package/semver) expressions are supported.

This library is based on stdlib's [SemanticVersion](https://crystal-lang.org/api/master/SemanticVersion.html).

## Installation

Add the dependency to your `shard.yml`:

```yaml
dependencies:
  semantic_compare:
    github: j8r/semantic_compare
```

## Usage

```crystal
require "semantic_compare"

# Compare with simple expressions
semantic_version = SemanticVersion.new "1.2.3"
SemanticCompare.version semantic_version, "1.2.0 - 1.4.0"

# Compare with 'or' `||` signs
SemanticCompare.expression "1.2.3", ">=1.0.4 || <2.0.0 || ~1.2.1"
```

## License

Copyright (c) 2017-2019 Julien Reichardt - ISC License
