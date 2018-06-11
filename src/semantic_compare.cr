require "semantic_version"

module SemanticCompare
  def self.expression(main_version : String, expression : String)
    expression.split(" || ").each do |part|
      # Hyphen ranges
      if part.includes? " - "
        part1, part2 = part.split " - "
        return true if compare(part1, "<=", main_version) && compare(main_version, "<=", part2)
      else
        array = part.split ' '
        case array.size
        when 1
          return true if version main_version, array[0]
        when 2
          return true if version(main_version, array[0]) && version main_version, array[1]
        else
          raise "no more than two conditions are allowed in an expression: add an 'or' sign between expressions like `#{array[0]} #{array[1]} || #{array[2]}`"  
        end
      end
    end
  end

  # Compare versions without ||
  macro compare(version, sign, expr)
    SemanticVersion.parse({{version}}) {{sign.id}} SemanticVersion.parse {{expr}}
  end

  macro double_compare(first_expr, version, second_expr)
    SemanticVersion.parse({{first_expr}}.lchop) <= SemanticVersion.parse({{version}}) < SemanticVersion.parse {{second_expr}}
  end

  def self.version(main_version : String, expr : String)
    case expr
    # Caret Ranges
    when .starts_with? "^0.0."
      double_compare expr, main_version, "0.0.#{expr.split('.')[2].to_i + 1}"
    when .starts_with? "^0."
      double_compare expr, main_version, "0.#{expr.split('.')[1].to_i + 1}.0"
    when .starts_with? '^'
      double_compare expr, main_version, "#{expr.lchop.split('.')[0].to_i + 1}.0.0"
      # Tilde Ranges
    when .starts_with? '~'
      double_compare expr, main_version, "#{expr.lchop.split('.')[0]}.#{expr.split('.')[1].to_i + 1}.0"
      # Hyphen ranges
    when .includes? " - "
      part1, part2 = expr.split " - "
      compare(part1, "<=", main_version) && compare(main_version, "<=", part2)
      # Comparisons
    when .starts_with? ">=" then compare main_version, ">=", expr[2..-1]
    when .starts_with? "<=" then compare main_version, "<=", expr[2..-1]
    when .starts_with? '<'  then compare main_version, '<', expr.lchop
    when .starts_with? '>'  then compare main_version, '>', expr.lchop
    else
      compare main_version, "==", expr
    end
  end
end
