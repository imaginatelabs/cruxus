require "confstruct"
require "rspec"

require "./lib/core/cxconf"

include Confstruct

describe CxConf do
  describe "#singleton" do
    context "when version configuration has been read in" do
      it "can access configurations keys as class variables" do
        expect(CxConf.version).to eq("1.0.0")
      end
    end
  end
end
