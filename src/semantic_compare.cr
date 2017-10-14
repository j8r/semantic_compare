require "semantic_version"

class SemanticCompare
  def self.expression(ver0 : String, expression : String)
    expression.to_s.split(" || ").each do |part|
      # If it's a hyphen range
      if part =~ /.* - .*/
        return true if version(ver0, expression)
      else
        array = part.to_s.split(" ")
        if array[2]?
          raise "no more than two conditions are allowed in an expression: add an 'or' sign `||` before \"#{array[0]}\""
        elsif array[1]?
          return true if version(ver0, array[0]) && version(ver0, array[1])
        else
          return true if version(ver0, array[0])
        end
      end
    end
  end
  # Compare versions without ||
  macro compare(version, sign, expr)
    SemanticVersion.parse({{version}}) {{sign.id}} SemanticVersion.parse({{expr}})
  end
  macro double_compare(expr, version, expr1)
    SemanticVersion.parse({{expr}}) <= SemanticVersion.parse({{version}}) < SemanticVersion.parse({{expr1}})
  end

  def self.version(ver0 : String, expr : String)
    case expr
    # Caret Ranges
    when /^\^0\.0\..*/
       double_compare expr[1..-1], ver0, "0.0.#{expr.split(".")[2].to_i + 1}"
    when /^\^0\..*/
      double_compare expr[1..-1], ver0, "0.#{expr.split(".")[1].to_i + 1}.0"
    when /^\^.*/
      double_compare expr[1..-1], ver0, "#{expr[1..-1].split(".")[0].to_i + 1}.0.0"
    # Tilde Ranges
    when /~.*/
      double_compare expr[1..-1], ver0, "#{expr[1..-1].split(".")[0]}.#{expr.split(".")[1].to_i + 1}.0"
    # Hyphen Ranges
    when /.* - .*/
      SemanticVersion.parse(expr.split(" - ")[0]) <= SemanticVersion.parse(ver0) <= SemanticVersion.parse(expr.split(" - ")[1])
    # Comparisons
    when /^>=.*/ then compare ver0, ">=", expr[2..-1]
    when /^<=.*/ then compare ver0, "<=", expr[2..-1]
    when /^\<.*/ then compare ver0, "<",  expr[1..-1]
    when /^\>.*/ then compare ver0, ">",  expr[1..-1]
    else
      compare ver0, "==", expr
    end
  end
end
