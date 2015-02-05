require "rspec"
require_relative "../../lib/core/plugin_manager"

describe PluginManager do
  let(:plugin_manager) { PluginManager }

  context "plugin methods" do
    before do
      allow(ConfUtils).to receive(:get_cxconf_paths)
        .with("plugins/tests/")
        .and_return(%W(#{File.dirname(__FILE__)}/plugins/tests))
    end

    describe "#plugin_files" do
      context "when plugin files exist under the specified dirname" do
        subject do
          plugin_manager.plugin_files("test", "plugins/tests/", "**/*test*")
        end
        it "return an array of plugins of the same type" do
          expect(subject.size).to eq 2
          expect(subject[0].plugin_type).to eq("test")
          expect(subject[1].plugin_type).to eq("test")
        end
      end
    end

    describe "#plugin" do
      context "when plugin files exist in default directories" do
        subject { plugin_manager.plugins("test") }
        it "return an array of plugins of the same type" do
          expect(subject.size).to eq 2
          expect(subject[0].plugin_type).to eq("test")
          expect(subject[1].plugin_type).to eq("test")
        end
      end
    end
  end
end
