require "confstruct"
require "rspec"
require "./lib/modules/workflows/conf/steps"

include Confstruct

describe ConfWorkflow::Steps do
  let(:subject) { ConfWorkflow::Steps.new(
      {
          "foo" => "bar", "barr" => "mee", "rea" => "so", "foo1" => "dodecine",
          "sub" => {
              "jim" => "bob",
              "garth" => "bag",
              "read" => "gooder",
              "subsub" => {
                  "noo" => "real",
                  "gre" => "ben"
              }
          },
          "sub2" => {
              "to" => "fr0",
              "sub2sub" => {
                  "yo" => "go",
                  "sub2subsub" => {
                      "reagal" => "yo"
                  }
              }
          }
      }
    )
  }

  describe ".select" do
    context "when multiple similar configuration keys and values exist" do
      it "returns multiple values" do
        expect(subject.select("bar")).to eq("foo" => "bar", "barr" => "mee")
      end
    end

    context "when no keys or values matches" do
      it "returns an empty hash" do
        expect(subject.select("far")).to eq({})
      end
    end
  end

  context "when keys or values matches" do
    it "when multiple similar configuration keys, sub keys and values exist" do
      expect(subject.select("rea")).to eq("rea" => "so",
                                          "sub" => {
                                              "read" => "gooder",
                                              "subsub" =>{
                                                  "noo" => "real"
                                              }
                                          },
                                          "sub2" =>{
                                              "sub2sub" =>{
                                                  "sub2subsub" =>{
                                                      "reagal" => "yo"
                                                  }
                                              }
                                          }
                                       )
    end
  end

  describe ".key" do
    context "when multiple similar configuration keys and values exist" do
      it "returns only a unique value of key" do
        expect(subject.key("foo")).to eq("bar")
      end
    end

    context "when no matching key exist" do
      it "returns nil" do
        expect(subject.key("soo")).to eq(nil)
      end
    end
  end

end