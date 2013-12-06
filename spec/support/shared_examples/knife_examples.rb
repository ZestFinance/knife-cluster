shared_examples_for "knife that validates environment and cluster_tag" do
  let(:knife) {described_class.new}
  subject {knife.validate!}

  before do
    knife.setup_config
    $stderr.reopen("/dev/null", "w")
  end

  after { Chef::Config[:environment] = nil }

  context "when chef-env is not provided with -E" do
    before {knife.config[:environment] = nil}
    it "should error" do
      expect {subject}.to raise_error SystemExit
      knife.errors.should include "You must provide an environment (-E environment). "+
        "Environment name should be one of #{Environment.all.keys.join(", ")}"
    end
  end

  context "when the environment is not valid" do
    before {knife.config[:environment] = "invalid_environment"}
    it "should error" do
      expect {subject}.to raise_error SystemExit
      knife.errors.should include "You must provide an environment (-E environment). "+
        "Environment name should be one of #{Environment.all.keys.join(", ")}"
    end
  end

  context "when the environment is valid" do
    Environment.all.keys.each do |env|
      before {knife.config[:environment] = env}
      it "should not complain about environment" do
        knife.errors.should_not include "You must provide an environment (-E environment). "+
          "Environment name should be one of #{Environment.all.keys.join(", ")}"
      end
    end
  end

  context "when cluster-tag is not provided" do
    before {knife.config[:cluster_tag] = nil}
    it "should error" do
      expect {subject}.to raise_error SystemExit
      knife.errors.should include "You must provide a cluster_tag with the -t option"
    end
  end

  context "when env is valid and cluster tag is provided" do
    before do
      knife.instance_variable_set('@environment', "development")
      knife.instance_variable_set('@color', "greenish")
      knife.instance_variable_set('@base_domain', "spotloan.com")
      knife.instance_variable_set('@region', "us-west-1")
    end

    it "should not error" do
      expect {subject}.to_not raise_error SystemExit
      knife.errors.should be_empty
    end
  end
end
