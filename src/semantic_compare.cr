require "semantic_version"

module SemanticCompare
  def self.expression(main_version : String, expression : String)
    expression.to_s.split(" || ").each do |part|
      # Hyphen ranges
      if part.includes? " - "
        parts = part.split " - "
        return true if compare(parts[0], "<=", main_version) && compare(main_version, "<=", parts[1])
      else
        array = part.to_s.split ' '
        case array.size
        when 2
          return true if version(main_version, array[0]) && version main_version, array[1]
        when 3
          raise "no more than two conditions are allowed in an expression: add an 'or' sign `||` before " + array[2]
        else
          return true if version main_version, array[0]
        end
      end
    end
  end

  # Compare versions without ||
  macro compare(version, sign, expr)
    SemanticVersion.parse({{version}}) {{sign.id}} SemanticVersion.parse {{expr}}
  end

  macro double_compare(first_expr, version, second_expr)
    SemanticVersion.parse({{first_expr}}[1..-1]) <= SemanticVersion.parse({{version}}) < SemanticVersion.parse {{second_expr}}
  end

  def self.version(main_version : String, expr : String)
    case
    # Caret Ranges
    when expr.starts_with? "^0.0."
      double_compare expr, main_version, "0.0.#{expr.split('.')[2].to_i + 1}"
    when expr.starts_with? "^0."
      double_compare expr, main_version, "0.#{expr.split('.')[1].to_i + 1}.0"
    when expr.starts_with? '^'
      double_compare expr, main_version, "#{expr[1..-1].split('.')[0].to_i + 1}.0.0"
      # Tilde Ranges
    when expr.starts_with? '~'
      double_compare expr, main_version, "#{expr[1..-1].split('.')[0]}.#{expr.split('.')[1].to_i + 1}.0"
      # Hyphen ranges
    when expr.includes? " - "
      parts = expr.split " - "
      compare(parts[0], "<=", main_version) && compare(main_version, "<=", parts[1])
      # Comparisons
    when expr.starts_with? ">=" then compare main_version, ">=", expr[2..-1]
    when expr.starts_with? "<=" then compare main_version, "<=", expr[2..-1]
    when expr.starts_with? '<'  then compare main_version, '<', expr[1..-1]
    when expr.starts_with? '>'  then compare main_version, '>', expr[1..-1]
    else
      compare main_version, "==", expr
    end
  end
end
