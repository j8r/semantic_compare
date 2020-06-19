crystal_doc_search_index_callback({"repository_name":"github.com/j8r/semantic_compare","body":"# SemanticCompare\n\n[![Build Status](https://cloud.drone.io/api/badges/j8r/semantic_compare/status.svg)](https://cloud.drone.io/j8r/semantic_compare)\n[![ISC](https://img.shields.io/badge/License-ISC-blue.svg?style=flat-square)](https://en.wikipedia.org/wiki/ISC_license)\n\nCompare semver versions using semantic expressions.\n\nMost of the [npm's semver implementation](https://www.npmjs.com/package/semver) expressions are supported.\n\nThis library is based on stdlib's [SemanticVersion](https://crystal-lang.org/api/master/SemanticVersion.html).\n\n## Documentation\n\nhttps://j8r.github.io/semantic_compare\n\n## Installation\n\nAdd the dependency to your `shard.yml`:\n\n```yaml\ndependencies:\n  semantic_compare:\n    github: j8r/semantic_compare\n```\n\n## Usage\n\n### Compare with simple expressions\n\n```crystal\nrequire \"semantic_compare\"\n\nsemantic_version = SemanticVersion.new \"1.2.3\"\n\nSemanticCompare.simple_expression semantic_version, \"<1.5.0\"        #=> true\nSemanticCompare.simple_expression semantic_version, \"1.2.0 - 1.4.0\" #=> true\n```\n\n### Compare with complex expressions, which can include 'or' `||` signs\n```crystal\nrequire \"semantic_compare\"\n\n# Compare with simple expressions\nsemantic_version = SemanticVersion.new \"1.2.3\"\n\nSemanticCompare.complex_expression semantic_version, \">1.2.3 <2.0.0\"               #=> true\nSemanticCompare.complex_expression semantic_version, \">=1.0.4 || <2.0.0 || ~1.2.1\" #=> true\n```\n\n## License\n\nCopyright (c) 2017-2020 Julien Reichardt - ISC License\n","program":{"html_id":"github.com/j8r/semantic_compare/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"superclass":null,"ancestors":[],"locations":[],"repository_name":"github.com/j8r/semantic_compare","program":true,"enum":false,"alias":false,"aliased":"","const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"github.com/j8r/semantic_compare/SemanticCompare","path":"SemanticCompare.html","kind":"module","full_name":"SemanticCompare","name":"SemanticCompare","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"semantic_compare.cr","line_number":3,"url":"https://github.com/j8r/semantic_compare/blob/2d941fccebc901fe5a8b261508040df30e8fa01c/src/semantic_compare.cr"}],"repository_name":"github.com/j8r/semantic_compare","program":false,"enum":false,"alias":false,"aliased":"","const":false,"constants":[],"included_modules":[],"extended_modules":[{"html_id":"github.com/j8r/semantic_compare/SemanticCompare","kind":"module","full_name":"SemanticCompare","name":"SemanticCompare"}],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[{"id":"complex_expression(semantic_version:SemanticVersion,expression:String):Bool-instance-method","html_id":"complex_expression(semantic_version:SemanticVersion,expression:String):Bool-instance-method","name":"complex_expression","doc":"Returns true if a version matches the complex expression, which can include \"or\" `||` signs.\n```\nsemantic_version = SemanticVersion.parse \"1.2.3\"\nSemanticCompare.complex_expression semantic_version, \">=1.0.4 || <2.0.0 || ~1.2.1\" # => true\n```","summary":"<p>Returns true if a version matches the complex expression, which can include \"or\" <code>||</code> signs.</p>","abstract":false,"args":[{"name":"semantic_version","doc":null,"default_value":"","external_name":"semantic_version","restriction":"SemanticVersion"},{"name":"expression","doc":null,"default_value":"","external_name":"expression","restriction":"String"}],"args_string":"(semantic_version : SemanticVersion, expression : String) : Bool","source_link":"https://github.com/j8r/semantic_compare/blob/2d941fccebc901fe5a8b261508040df30e8fa01c/src/semantic_compare.cr#L11","def":{"name":"complex_expression","args":[{"name":"semantic_version","doc":null,"default_value":"","external_name":"semantic_version","restriction":"SemanticVersion"},{"name":"expression","doc":null,"default_value":"","external_name":"expression","restriction":"String"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Bool","visibility":"Public","body":"expression.split(\" || \") do |parts|\n  if parts.includes?(\" - \")\n    if hyphen_range(semantic_version, parts)\n      return true\n    end\n  else\n    part1, _, part2 = parts.partition(' ')\n    if part2.empty?\n      if simple_expression(semantic_version, part1)\n        return true\n      end\n    else\n      if (simple_expression(semantic_version, part1)) && (simple_expression(semantic_version, part2))\n        return true\n      end\n    end\n  end\nend\nfalse\n"}},{"id":"simple_expression(semantic_version:SemanticVersion,expression:String):Bool-instance-method","html_id":"simple_expression(semantic_version:SemanticVersion,expression:String):Bool-instance-method","name":"simple_expression","doc":"Returns true if a version matches the simple expression.\n\n```\nsemantic_version = SemanticVersion.parse \"1.2.3\"\nSemanticCompare.simple_expression semantic_version, \"<1.5.0\"        # => true\nSemanticCompare.simple_expression semantic_version, \"1.2.0 - 1.4.0\" # => true\n```","summary":"<p>Returns true if a version matches the simple expression.</p>","abstract":false,"args":[{"name":"semantic_version","doc":null,"default_value":"","external_name":"semantic_version","restriction":"SemanticVersion"},{"name":"expression","doc":null,"default_value":"","external_name":"expression","restriction":"String"}],"args_string":"(semantic_version : SemanticVersion, expression : String) : Bool","source_link":"https://github.com/j8r/semantic_compare/blob/2d941fccebc901fe5a8b261508040df30e8fa01c/src/semantic_compare.cr#L48","def":{"name":"simple_expression","args":[{"name":"semantic_version","doc":null,"default_value":"","external_name":"semantic_version","restriction":"SemanticVersion"},{"name":"expression","doc":null,"default_value":"","external_name":"expression","restriction":"String"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Bool","visibility":"Public","body":"if expression.includes?(\" - \")\n  hyphen_range(semantic_version, expression)\nelse\n  if stripped_expr = expression.lchop?(\"^0.0.\")\n    double_compare(expression, semantic_version, \"0.0.#{stripped_expr.to_i + 1}\")\n  else\n    if stripped_expr = expression.lchop?(\"^0.\")\n      double_compare(expression, semantic_version, \"0.#{(stripped_expr.partition('.'))[0].to_i + 1}.0\")\n    else\n      if stripped_expr = expression.lchop?('^')\n        double_compare(expression, semantic_version, \"#{(stripped_expr.partition('.'))[0].to_i + 1}.0.0\")\n      else\n        if stripped_expr = expression.lchop?('~')\n          part1, _, part2 = stripped_expr.partition('.')\n          double_compare(expression, semantic_version, \"#{part1}.#{(part2.partition('.'))[0].to_i + 1}.0\")\n        else\n          if stripped_expr = expression.lchop?(\">=\")\n            compare(semantic_version, \">=\", stripped_expr)\n          else\n            if stripped_expr = expression.lchop?(\"<=\")\n              compare(semantic_version, \"<=\", stripped_expr)\n            else\n              if stripped_expr = expression.lchop?('>')\n                compare(semantic_version, '>', stripped_expr)\n              else\n                if stripped_expr = expression.lchop?('<')\n                  compare(semantic_version, '<', stripped_expr)\n                else\n                  compare(semantic_version, \"==\", expression)\n                end\n              end\n            end\n          end\n        end\n      end\n    end\n  end\nend"}}],"macros":[],"types":[]}]}})