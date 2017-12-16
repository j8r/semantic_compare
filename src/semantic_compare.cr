require "semantic_version"

module SemanticCompare
  def self.expression(ver0 : String, expression : String)
    expression.to_s.split(" || ").each do |part|
      # Hyphen ranges
      if part =~ /(.*) - (.*)/
        return true if compare($1, "<=", ver0) && compare(ver0, "<=", $2)
      else
        array = part.to_s.split ' '
        if array[2]?
          raise "no more than two conditions are allowed in an expression: add an 'or' sign `||` before " + array[2]
        elsif array[1]?
          return true if version(ver0, array[0]) && version ver0, array[1]
        else
          return true if version ver0, array[0]
        end
      end
    end
  end

  # Compare versions without ||
  macro compare(version, sign, expr)
    SemanticVersion.parse({{version}}) {{sign.id}} SemanticVersion.parse {{expr}}
  end

  macro double_compare(expr, version, expr1)
    SemanticVersion.parse({{expr}}[1..-1]) <= SemanticVersion.parse({{version}}) < SemanticVersion.parse {{expr1}}
  end

  def self.version(ver0 : String, expr : String)
    case
    # Caret Ranges
    when expr.starts_with? "^0.0."
      double_compare expr, ver0, "0.0.#{expr.split('.')[2].to_i + 1}"
    when expr.starts_with? "^0."
      double_compare expr, ver0, "0.#{expr.split('.')[1].to_i + 1}.0"
    when expr.starts_with? '^'
      double_compare expr, ver0, "#{expr[1..-1].split('.')[0].to_i + 1}.0.0"
      # Tilde Ranges
    when expr.starts_with? '~'
      double_compare expr, ver0, "#{expr[1..-1].split('.')[0]}.#{expr.split('.')[1].to_i + 1}.0"
      # Hyphen ranges
    when expr =~ /(.*) - (.*)/
      compare($1, "<=", ver0) && compare(ver0, "<=", $2)
      # Comparisons
    when expr.starts_with? ">=" then compare ver0, ">=", expr[2..-1]
    when expr.starts_with? "<=" then compare ver0, "<=", expr[2..-1]
    when expr.starts_with? '<'  then compare ver0, '<', expr[1..-1]
    when expr.starts_with? '>'  then compare ver0, '>', expr[1..-1]
    else
      compare ver0, "==", expr
    end
  end
end
