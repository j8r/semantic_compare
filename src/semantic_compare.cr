require "semantic_version"

module SemanticCompare
  extend self

  # Returns true if a version matches the complex expression, which can include "or" `||` signs.
  # ```
  # semantic_version = SemanticVersion.parse "1.2.3"
  # SemanticCompare.complex_expression semantic_version, ">=1.0.4 || <2.0.0 || ~1.2.1" # => true
  # ```
  def complex_expression(semantic_version : SemanticVersion, expression : String) : Bool
    expression.split " || " do |parts|
      # Hyphen ranges
      if parts.includes? " - "
        return true if hyphen_range semantic_version, parts
      else
        part1, _, part2 = parts.partition ' '
        if part2.empty?
          return true if simple_expression semantic_version, part1
        else
          return true if simple_expression(semantic_version, part1) && simple_expression(semantic_version, part2)
        end
      end
    end
    false
  end

  private macro compare(semantic_version, sign, expr)
    semantic_version {{sign.id}} SemanticVersion.parse {{expr}}
  end

  private def double_compare(first_expr : String, semantic_version : SemanticVersion, second_expr : String)
    SemanticVersion.parse(first_expr.lchop) <= semantic_version < SemanticVersion.parse second_expr
  end

  private def hyphen_range(semantic_version : SemanticVersion, expression : String) : Bool
    part1, _, part2 = expression.partition " - "
    compare(semantic_version, '>', part1) && compare(semantic_version, "<=", part2)
  end

  # Returns true if a version matches the simple expression.
  #
  # ```
  # semantic_version = SemanticVersion.parse "1.2.3"
  # SemanticCompare.simple_expression semantic_version, "<1.5.0"        # => true
  # SemanticCompare.simple_expression semantic_version, "1.2.0 - 1.4.0" # => true
  # ```
  def simple_expression(semantic_version : SemanticVersion, expression : String) : Bool
    # Hyphen range
    if expression.includes? " - "
      hyphen_range semantic_version, expression
      # Caret Ranges
    elsif stripped_expr = expression.lchop? "^0.0."
      double_compare expression, semantic_version, "0.0.#{stripped_expr.to_i + 1}"
    elsif stripped_expr = expression.lchop? "^0."
      double_compare expression, semantic_version, "0.#{stripped_expr.partition('.')[0].to_i + 1}.0"
    elsif stripped_expr = expression.lchop? '^'
      double_compare expression, semantic_version, "#{stripped_expr.partition('.')[0].to_i + 1}.0.0"
      # Tilde Ranges
    elsif stripped_expr = expression.lchop? '~'
      part1, _, part2 = stripped_expr.partition '.'
      double_compare expression, semantic_version, "#{part1}.#{part2.partition('.')[0].to_i + 1}.0"
      # Comparisons
    elsif stripped_expr = expression.lchop? ">="
      compare semantic_version, ">=", stripped_expr
    elsif stripped_expr = expression.lchop? "<="
      compare semantic_version, "<=", stripped_expr
    elsif stripped_expr = expression.lchop? '>'
      compare semantic_version, '>', stripped_expr
    elsif stripped_expr = expression.lchop? '<'
      compare semantic_version, '<', stripped_expr
    else
      compare semantic_version, "==", expression
    end
  end
end
