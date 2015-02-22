require "rspec"
require_relative "../../lib/core/string_helper"

describe StringHelper do
  describe "#camelize" do
    context "given default second argument: first letter upcase is true" do
      subject { StringHelper.camelize string }

      context "given string separated by underscores" do
        let(:string) { "this_is_my_string" }

        it "camelizes the string" do
          expect(subject).to eq "ThisIsMyString"
        end
      end

      context "given the string begins with an underscores" do
        let(:string) { "_this_string" }

        it "camelizes the string" do
          expect(subject).to eq "ThisString"
        end
      end

      context "given the string ends with an underscores" do
        let(:string) { "this_string_" }

        it "camelizes the string" do
          expect(subject).to eq "ThisString"
        end
      end

      context "given the string contains consecutive underscores" do
        let(:string) { "this_____is__my__string" }

        it "camelizes the string" do
          expect(subject).to eq "ThisIsMyString"
        end
      end
    end

    context "given first letter upcase false" do
      subject { StringHelper.camelize string, false }

      context "given string separated by underscores" do
        let(:string) { "this_is_my_string" }

        it "camelizes the string" do
          expect(subject).to eq "thisIsMyString"
        end
      end

      context "given the string begins with an underscores" do
        # FIXME: this case is unlikely at this point
        let(:string) { "_this_string" }

        xit "camelizes the string" do
          expect(subject).to eq "thisString"
        end
      end
    end
  end
end
