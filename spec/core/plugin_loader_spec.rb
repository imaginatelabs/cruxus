require "rspec"
require_relative "../../lib/core/loaders/plugin_loader"

describe PluginLoader do
  let(:plugin_manager) { PluginLoader }

  context "plugin methods" do
    before do
      allow(ConfDirHelper).to receive(:get_conf_paths)
        .with("plugins/")
        .and_return(%W(#{File.dirname(__FILE__)}/plugins/))
    end

    describe "#find_plugin_files_by_pattern" do
      context "when plugin files exist under the specified dirname" do
        subject do
          plugin_manager.find_plugin_files_by_pattern("test", "plugins/", "**/*test*")
        end

        it "return an array of plugins of the same type" do
          expect(subject.size).to eq 2
          expect(subject[0].plugin_type).to eq("test")
          expect(subject[1].plugin_type).to eq("test")
        end
      end

      context "when no plugin files exist under the specified dirname" do
        subject do
          plugin_manager.find_plugin_files_by_pattern("_", "plugins/", "**/*foo*")
        end

        it { is_expected.to eq nil }
      end
    end

    describe "#find_plugin_files" do
      context "when plugin files exist in default directories" do
        subject { plugin_manager.find_plugin_files("test") }

        it "return an array of plugins of the same type" do
          expect(subject.size).to eq 2
          expect(subject[0].plugin_type).to eq("test")
          expect(subject[1].plugin_type).to eq("test")
        end
      end

      context "when no plugin files exist in default directories" do
        subject { plugin_manager.find_plugin_files("foo") }

        it { is_expected.to eq nil }
      end
    end

    describe "#find_plugin_file" do
      context "when plugin exists that matches exactly" do
        subject { plugin_manager.find_plugin_file("my_plugin", "test") }

        it "return an array of plugins of the same type" do
          expect(subject.module_class_name).to eq("MyPluginTest::MyPlugin")
          expect(subject.plugin_type).to eq("test")
        end
      end

      context "when no plugin_file name matches but other files of the same type exist" do
        subject { plugin_manager.find_plugin_file("no_plugin", "test") }

        it { is_expected.to eq nil }
      end
    end

    describe "#load_plugin" do
      context "given a plugin exists" do
        subject do
          plugin_manager.load_plugin("my_plugin", "test", "my_logger", "my_options", "my_conf")
        end

        it "load plugin into file" do
          plugin = subject
          expect(plugin.logger).to eq("my_logger")
          expect(plugin.options).to eq("my_options")
          expect(plugin.conf).to eq("my_conf")
        end
      end

      context "given a plugin doesn't exists" do
        subject do
          plugin_manager.load_plugin("no_plugin", "test", "my_logger", "my_options", "my_conf")
        end

        it { is_expected.to eq nil }
      end
    end
  end
end
