require "rspec"
require_relative "../../../lib/core/helpers/conf_dir_helper"

describe ConfDirHelper do
  let(:conf_dir_helper) { ConfDirHelper }
  subject { conf_dir_helper }

  describe "#load_config_files" do
    context "when multiple configuration files are loaded" do
      it "overrides duplicate values" do
        conf = subject.load_config_files(%w(spec/core/conf/.radial1.yml
                                            spec/core/conf/.radial2.yml))
        expect(conf.my_value_override).to eq("my value override")
        expect(conf.my_value_no_override).to eq("my value no override")
      end
    end

    context "when configuration file are missing" do
      it "ignores the missing files" do
        subject.load_config_files(%w(foo/core/conf/.radial.yml1
                                     foo/core/conf/.radial.yml2))
      end
    end
  end

  describe "#get_conf_paths" do
    before do
      allow(conf_dir_helper).to receive(:radial_dir).and_return("/usr/bin/radial")
      allow(conf_dir_helper).to receive(:shared_dir).and_return("/etc")
      allow(conf_dir_helper).to receive(:user_dir).and_return("/home/my_user")
      allow(conf_dir_helper).to receive(:working_dir).and_return("/home/my_user/code/my_project")
    end

    context "when paths exist or not on the system" do
      subject { conf_dir_helper.get_conf_paths }

      it "loads paths for configuration order" do
        expect(subject).to match_array(
                              %w(/usr/bin/radial/
                                 /etc/radial/
                                 /home/my_user/radial/
                                 /home/my_user/code/
                                 /home/my_user/code/my_project/)
                           )
      end
    end

    context "when passing in an extension path" do
      subject { conf_dir_helper.get_conf_paths(".radial.yml") }

      it "appended the extension path to the base path" do
        expect(subject).to match_array(
                               %w(/usr/bin/radial/.radial.yml
                                  /etc/radial/.radial.yml
                                  /home/my_user/radial/.radial.yml
                                  /home/my_user/code/.radial.yml
                                  /home/my_user/code/my_project/.radial.yml)
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
      subject { conf_dir_helper.ascend_dir dir, ".radial.yml" }
      it "returns directories appended with path value" do
        expect(subject).to match_array(
                             %w(/.radial.yml
                                /home/.radial.yml
                                /home/my_user/.radial.yml
                                /home/my_user/code/.radial.yml
                                /home/my_user/code/my_project/.radial.yml
                                /home/my_user/code/my_project/sub/.radial.yml
                                /home/my_user/code/my_project/sub/folders/.radial.yml)
                           )
      end
    end

    context "given a path argument and a termination dir" do
      subject { conf_dir_helper.ascend_dir dir, ".radial.yml", "/home/my_user" }
      it "returns directories before the termination dir appended with path value" do
        expect(subject).to match_array(
                             %w(/home/my_user/code/.radial.yml
                                /home/my_user/code/my_project/.radial.yml
                                /home/my_user/code/my_project/sub/.radial.yml
                                /home/my_user/code/my_project/sub/folders/.radial.yml)
                           )
      end
    end
  end
end
