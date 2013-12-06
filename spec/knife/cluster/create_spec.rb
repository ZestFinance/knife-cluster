require 'spec_helper'

describe Chef::Knife::ClusterCreate do
  let(:cc) { cluster_create = Chef::Knife::ClusterCreate.new }
  let(:databag) {mock(Chef::DataBag)}
  let(:cluster) { Cluster.new(color: 'greenish', environment: 'development') }

  before {
    Cluster.stub(:find).and_return(cluster)
    described_class.any_instance.stub(:cluster).and_return(cluster)
  }

  describe "#validate!" do
    it_should_behave_like "knife that validates environment and cluster_tag"
  end

  describe "#run" do
    let(:created_hosts) {[["d000", "fake_runltst"], ["d999", "fake_runlist"]]}
    before do
      cc.name_args            = ["greenish"]
      cc.config[:environment] = "development"
      cc.config[:base_domain] = "spotloan.com"
      cc.stub(:puts)
    end

    context "when cluster definition is found" do
      it "should call create_new_cluster with servers and databag_item" do
        cc.should_receive(:confirm_or_prompt_for_databag).and_return(databag)
        cc.should_receive(:create_new_cluster).with(ClusterConfig.env_config(:development), databag).and_return(created_hosts)
        cc.stub(:over_ec2_limit?).and_return false
        cc.run
      end
    end
  end

  describe "#create_new_cluster" do
    before do
      cc.config[:environment] = "development"
      cc.config[:cluster_tag] = "greenish"
    end

    context "when servers and databag item are provided" do
      let(:ic) { mock(Chef::Knife::InstanceCreate) }
      let(:config_mock) { mock(Chef::Config) }
      before do
        Chef::Knife::InstanceCreate.should_receive(:new).and_return(ic)
        ic.should_receive(:run).exactly(1).times
        ic.should_receive(:config).at_least(1).and_return(config_mock)
        config_mock.should_receive(:[]).at_least(1)
        config_mock.should_receive(:[]=).at_least(1)
        config_mock.should_receive(:merge!).exactly(1).times
        cc.should_receive(:set_original_nodes).exactly(1).times
        cc.should_receive(:generate_hostname).exactly(1).times.and_return("fake_hostname")
        cc.should_receive(:create_color_dns).exactly(1).times
        ChefEnv::Region.stub(:get).and_return(ChefEnv::Region::US_EAST_1)
      end

      it "should create a new cluster" do
        cc.create_new_cluster(ClusterConfig.env_config(:development), databag)
      end
    end
  end

  describe "#create_color_dns" do
    before do
      cc.config[:environment] = "development"
      cc.instance_variable_set(:@color, "greenish")
      cc.instance_variable_set(:@base_domain, "spotloan.com")
    end

    let(:hostname) { 'fake_hostname' }

    it "should create dns names" do
      cc.should_receive(:point_dns_record).with('www.greenish.spotloan.com', cc.fqdn(hostname), false)

      cc.create_color_dns ['www'], hostname
    end
  end

  describe "#confirm_or_prompt_for_databag" do
    before do
      cc.config[:environment] = "development"
      cc.config[:cluster_tag] = "greenish"
      cc.config[:region] = 'us-west-1'
      cc.stub(:ask_question).and_return('develop')
      databag.should_receive(:save).and_return(databag)
    end

    let(:databag) { Hash.new }

    context "when the databag exists" do
      before do
        cluster.should_receive(:cluster_databag).and_return(databag)
      end

      context "but it has no keys" do
        it "should set the correct revisions in the databag if they don't exist" do
          dbag = cc.send :confirm_or_prompt_for_databag
          dbag.should == {
            'interview'   => { 'revision' => 'develop' },
            'servicing'   => { 'revision' => 'develop' },
            'www'         => { 'revision' => 'develop' },
            'www_service' => { 'revision' => 'develop' },
            'www_static'  => { 'revision' => 'develop' },
            'comms_hub'   => { 'revision' => 'develop' },
            'chubs'       => { 'revision' => 'develop' },
            'region'      => 'us-west-1'
          }
        end
      end

      context "and it has an existing key" do
        let(:databag) { { 'interview' => { 'revision' => 'existing'} } }

        it "should not overwrite existing revisions" do
          dbag = cc.send :confirm_or_prompt_for_databag
          dbag.should == {
            'interview'   => { 'revision' => 'existing' },
            'servicing'   => { 'revision' => 'develop' },
            'www'         => { 'revision' => 'develop' },
            'www_service' => { 'revision' => 'develop' },
            'www_static'  => { 'revision' => 'develop' },
            'comms_hub'   => { 'revision' => 'develop' },
            'chubs'       => { 'revision' => 'develop' },
            'region'      => 'us-west-1'
          }
        end
      end
    end

    context "when it could not find cluster definition databag" do
      before do
        cluster.should_receive(:cluster_databag).and_return(nil)
      end
      it "should call create_cluster_databag" do
        cc.should_receive(:create_cluster_databag).and_return(databag)
        cc.send :confirm_or_prompt_for_databag
      end
    end
  end
end
