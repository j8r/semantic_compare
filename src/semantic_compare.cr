require "semantic_version"

class SemanticCompare
  def self.expression(ver0 : String, expression : String)
    expression.to_s.split(" || ").each do |part|
      array = part.to_s.split(" ")
      # If it's a tilde range
      if part =~ /.* - .*/
        puts part
        return true if version(ver0, expression)
      elsif array[2]?
        raise "no more than two conditions are allowed in an expression: add an 'or' sign `||` before \"#{array[0]}\""
      elsif array[1]?
        return true if version(ver0, array[0]) && version(ver0, array[1])
      else
        return true if version(ver0, array[0])
      end
    end
  end
  # Compare versions without ||
  def self.version(ver0 : String, expr : String)
    case expr
    # Caret Ranges
    when /^\^0\.0\..*/
       SemanticVersion.parse(expr[1..-1]) <= SemanticVersion.parse(ver0) < SemanticVersion.parse("0.0.#{expr.split(".")[2].to_i + 1}")
    when /^\^0\..*/
      SemanticVersion.parse(expr[1..-1]) <= SemanticVersion.parse(ver0) < SemanticVersion.parse("0.#{expr.split(".")[1].to_i + 1}.0")
    when /^\^.*/
      SemanticVersion.parse(expr[1..-1]) <= SemanticVersion.parse(ver0) < SemanticVersion.parse("#{expr[1..-1].split(".")[0].to_i + 1}.0.0")
    # Tilde Ranges
    when /~.*/
      SemanticVersion.parse(expr[1..-1]) <= SemanticVersion.parse(ver0) < SemanticVersion.parse("#{expr[1..-1].split(".")[0]}.#{expr.split(".")[1].to_i + 1}.0")
    # Hyphen Ranges
    when /.* - .*/
      SemanticVersion.parse(expr.split(" - ")[0]) <= SemanticVersion.parse(ver0) <= SemanticVersion.parse(expr.split(" - ")[1])
    # Comparisons
    when /^>=.*/
      SemanticVersion.parse(ver0) >= SemanticVersion.parse(expr[2..-1])
    when /^<=.*/
      SemanticVersion.parse(ver0) <= SemanticVersion.parse(expr[2..-1])
    when /^\<.*/
      SemanticVersion.parse(ver0) < SemanticVersion.parse(expr[1..-1])
    when /^\>.*/
      SemanticVersion.parse(ver0) > SemanticVersion.parse(expr[1..-1])
    else
      SemanticVersion.parse(ver0) == SemanticVersion.parse(expr)
    end
  end
end
