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

### Compare with simple expressions

```crystal
require "semantic_compare"

semantic_version = SemanticVersion.new "1.2.3"
SemanticCompare.simple_expression semantic_version, "<1.5.0"        #=> true
SemanticCompare.simple_expression semantic_version, "1.2.0 - 1.4.0" #=> true
```

### Compare with complex expressions, which can include 'or' `||` signs
```crystal
require "semantic_compare"

# Compare with simple expressions
semantic_version = SemanticVersion.new "1.2.3"

SemanticCompare.complex_expression semantic_version, ">=1.0.4 || <2.0.0 || ~1.2.1" #=> true
```

## License

Copyright (c) 2017-2019 Julien Reichardt - ISC License
