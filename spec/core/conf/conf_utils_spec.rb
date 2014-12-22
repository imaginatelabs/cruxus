require "rspec"
require "./lib/core/conf_utils"

describe ConfUtils do
  let(:conf_utils) { ConfUtils }
  subject { conf_utils }

  describe "#load_config_files" do
    context "when multiple configuration files are loaded" do
      it "overrides duplicate values" do
        cxconf = subject.load_config_files(%w(spec/core/conf/.cxconf1 spec/core/conf/.cxconf2))
        expect(cxconf.my_value_override).to eq("my value override")
        expect(cxconf.my_value_no_override).to eq("my value no override")
      end
    end

    context "when configuration file are missing" do
      it "ignores the missing files" do
        subject.load_config_files(%w(foo/core/conf/.cxconf1 foo/core/conf/.cxconf2))
      end
    end
  end

  describe "#get_cxconf_paths" do
    before do
      allow(conf_utils).to receive(:get_shared_dir).and_return("/etc")
      allow(conf_utils).to receive(:get_user_dir).and_return("/home/my_user")
      allow(conf_utils).to receive(:get_cx_dir).and_return("/usr/bin/cx")
      allow(conf_utils).to receive(:get_working_dir).and_return("/home/my_user/code/my_project")
    end

    context "when paths exist or not on the system" do
      it "loads paths for configuration order" do
          expect(subject.get_cxconf_paths).to match_array(%w(/usr/bin/cx/
                                                             /etc/cx/
                                                             /home/my_user/cx/
                                                             /home/my_user/code/my_project/cx/))
      end
    end

    context "when passing in an extension path" do
      it "appended the extension path to the base path" do
        expect(subject.get_cxconf_paths(".cxconf")).to match_array(%w(/usr/bin/cx/.cxconf
                                                                      /etc/cx/.cxconf
                                                                      /home/my_user/cx/.cxconf
                                                                      /home/my_user/code/my_project/cx/.cxconf))
      end
    end


    context "plugin methods" do
      before do
        allow(conf_utils).to receive(:get_cxconf_paths).with("plugins/tests/").and_return(%W(
                                                                              #{File.dirname(__FILE__)}/plugins/tests))
      end

      describe "#files" do
        context "when given an exiting directory" do
          context "using the default glob to match" do
            it "return all files in the directory" do
              expect(subject.files("plugins/tests/").to_s).to include(
                  "my_plugin_test.rb",
                  "my_plugin2_test.rb",
                  "unrelated_file.rb")
            end
          end

          context "when give a custom glob to match" do
            it "returns only the matching files" do
              expect(subject.files("plugins/tests/", "**/*plugin2*").to_s).to include("my_plugin2_test.rb")
            end
          end
        end
      end

      describe "#plugin_files" do
        context "when plugin files exist under the specified dirname" do
          subject { conf_utils.plugin_files("test","plugins/tests/","**/*test*") }
          it "return an array of plugins of the same type" do
            expect(subject.size).to eq 2
            expect(subject[0].plugin_type).to eq("test")
            expect(subject[1].plugin_type).to eq("test")
          end
        end
      end

      describe "#plugin" do
        context "when plugin files exist under default plugin directories using the plugin convention" do
          subject { conf_utils.plugins("test") }
          it "return an array of plugins of the same type" do
            expect(subject.size).to eq 2
            expect(subject[0].plugin_type).to eq("test")
            expect(subject[1].plugin_type).to eq("test")
          end
        end
      end
    end
  end
end
