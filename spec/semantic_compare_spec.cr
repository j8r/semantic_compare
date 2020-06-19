require "spec"
require "../src/semantic_compare"

describe SemanticCompare do
  describe "comparisons" do
    semantic_version = SemanticVersion.parse "1.2.3"
    it "compare simple expressions" do
      {"1.2.3", "^1.2.0", "~1.2.1", "<=1.2.3", ">=1.2.3", ">1.2.2", "<1.4.0", "1.2.0 - 1.3.0"}.each do |expr|
        SemanticCompare.simple_expression(semantic_version, expr).should be_true
      end
    end
    describe "complex expressions with 'or' `||`" do
      it "returns true" do
        {"1.2.3 || <=2.0.0", ">=1.0.4 || <=1.2.3", ">=1.2.0 || <1.4.0 || ~1.2.5", "1.2.0 - 1.3.0 || >0.0.1", ">=1.2.3 <2.0.0"}.each do |expr|
          SemanticCompare.complex_expression(semantic_version, expr).should be_true
        end
      end

      it "returns false" do
        {">3.2.1", "<1.0.0 || >2.0.0"}.each do |expr|
          SemanticCompare.complex_expression(semantic_version, expr).should be_false
        end
      end
    end
  end
end
