require "rspec"
require_relative "../../../lib/core/helpers/conf_dir_helper"

describe ConfDirHelper do
  let(:conf_dir_helper) { ConfDirHelper }
  subject { conf_dir_helper }

  describe "#load_config_files" do
    context "when multiple configuration files are loaded" do
      it "overrides duplicate values" do
        conf = subject.load_config_files(%w(spec/core/conf/.cxconf1
                                            spec/core/conf/.cxconf2))
        expect(conf.my_value_override).to eq("my value override")
        expect(conf.my_value_no_override).to eq("my value no override")
      end
    end

    context "when configuration file are missing" do
      it "ignores the missing files" do
        subject.load_config_files(%w(foo/core/conf/.cxconf1
                                     foo/core/conf/.cxconf2))
      end
    end
  end

  describe "#get_conf_paths" do
    before do
      allow(conf_dir_helper).to receive(:cx_dir).and_return("/usr/bin/cx")
      allow(conf_dir_helper).to receive(:shared_dir).and_return("/etc")
      allow(conf_dir_helper).to receive(:user_dir).and_return("/home/my_user")
      allow(conf_dir_helper).to receive(:working_dir).and_return("/home/my_user/code/my_project")
    end

    context "when paths exist or not on the system" do
      subject { conf_dir_helper.get_conf_paths }

      it "loads paths for configuration order" do
        expect(subject).to match_array(
                              %w(/usr/bin/cx/
                                 /etc/cx/
                                 /home/my_user/cx/
                                 /home/my_user/code/
                                 /home/my_user/code/my_project/)
                           )
      end
    end

    context "when passing in an extension path" do
      subject { conf_dir_helper.get_conf_paths(".cxconf") }

      it "appended the extension path to the base path" do
        expect(subject).to match_array(
                               %w(/usr/bin/cx/.cxconf
                                  /etc/cx/.cxconf
                                  /home/my_user/cx/.cxconf
                                  /home/my_user/code/.cxconf
                                  /home/my_user/code/my_project/.cxconf)
                              )
      end
    end
  end

  describe "#ascend_dir" do
    let(:dir) { "/home/my_user/code/my_project/sub/folders" }

    context "given a default arguments" do
      subject { conf_dir_helper.ascend_dir dir }
      it "returns directories" do
        expect(subject).to match_array(
                             %w(/
                                /home/
                                /home/my_user/
                                /home/my_user/code/
                                /home/my_user/code/my_project/
                                /home/my_user/code/my_project/sub/
                                /home/my_user/code/my_project/sub/folders/)
                           )
      end
    end

    context "given a path argument" do
      subject { conf_dir_helper.ascend_dir dir, ".cxconf" }
      it "returns directories appended with path value" do
        expect(subject).to match_array(
                             %w(/.cxconf
                                /home/.cxconf
                                /home/my_user/.cxconf
                                /home/my_user/code/.cxconf
                                /home/my_user/code/my_project/.cxconf
                                /home/my_user/code/my_project/sub/.cxconf
                                /home/my_user/code/my_project/sub/folders/.cxconf)
                           )
      end
    end

    context "given a path argument and a termination dir" do
      subject { conf_dir_helper.ascend_dir dir, ".cxconf", "/home/my_user" }
      it "returns directories before the termination dir appended with path value" do
        expect(subject).to match_array(
                             %w(/home/my_user/code/.cxconf
                                /home/my_user/code/my_project/.cxconf
                                /home/my_user/code/my_project/sub/.cxconf
                                /home/my_user/code/my_project/sub/folders/.cxconf)
                           )
      end
    end
  end
end
