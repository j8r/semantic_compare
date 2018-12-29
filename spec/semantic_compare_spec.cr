require "spec"
require "../src/semantic_compare"

describe SemanticCompare do
  describe "comparisons" do
    semantic_version = SemanticVersion.parse "1.2.3"
    it "compare simple comparisons" do
      ["1.2.3", "^1.2.0", "~1.2.1", "<=1.2.3", ">=1.2.3", ">1.2.2", "<1.4.0", "1.2.0 - 1.3.0"].each do |expr|
        SemanticCompare.version(semantic_version, expr).should be_true
      end
    end
    it "complex comparisons with 'or' `||`" do
      ["1.2.3 || <=2.0.0", ">=1.0.4 || <=1.2.3", ">=1.2.0 || <1.4.0 || ~1.2.5", "1.2.0 - 1.3.0 || >0.0.1"].each do |expr|
        SemanticCompare.expression(semantic_version, expr).should be_true
      end
    end
  end
end
