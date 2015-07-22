require "confstruct"
require "rspec"

require "./lib/core/conf"

include Confstruct

describe Conf do
  describe "#singleton" do
    context "when version configuration has been read in" do
      it "can access configurations keys as class variables" do
        expect(Conf.version).to eq("0.1.1")
      end
    end
  end
end
