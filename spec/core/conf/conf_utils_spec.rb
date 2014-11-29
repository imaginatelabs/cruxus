require "rspec"
require "./lib/core/conf_utils"

describe ConfUtils do
  let(:subject) { ConfUtils }

  describe ".load_config_files" do
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

  describe ".get_cxconf_paths" do
    before do
      allow(subject).to receive(:get_shared_dir).and_return("/etc")
      allow(subject).to receive(:get_user_dir).and_return("/home/my_user")
      allow(subject).to receive(:get_cx_dir).and_return("/usr/bin/cx")
      allow(subject).to receive(:get_working_dir).and_return("/home/my_user/code/my_project")
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
  end
end