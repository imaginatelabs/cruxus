require "rspec"

require "./lib/core/plugin_file"

describe PluginFile do
  let(:plugin_file) { PluginFile.new("/Users/user/cx/plugins/tests/my_plugin_test.rb","test") }

  context "given a type and a valid file path" do
    describe ".instance_name" do
      subject { plugin_file.instance_name }

      it "returns the instance of the plugin without the type in the name" do
        expect(subject).to eq("MyPlugin")
      end
    end

    describe ".plugin_name" do
      subject { plugin_file.plugin_name }

      it "returns the plugin name with the type in the name" do
        expect(subject).to eq("MyPluginTest")
      end
    end

    describe ".class_module" do
      subject { plugin_file.module_class_name }

      it "returns the full ruby namespace with module with class" do
        expect(subject).to eq("MyPluginTest::MyPlugin")
      end
    end

    describe ".absolute_path" do
      subject { plugin_file.absolute_path }

      it "returns the absolute path" do
        expect(subject).to eq("/Users/user/cx/plugins/tests/my_plugin_test.rb")
      end
    end

    describe ".type" do
      subject { plugin_file.plugin_type }

      it "returns the plugin type" do
        expect(subject).to eq("test")
      end
    end
  end
end