require 'spec_helper'

describe Cluster do
  describe '.new' do
    subject { described_class.new environment: 'some_environment', color: 'some_color' }
    its(:environment) { should == 'some_environment' }
    its(:color) { should == 'some_color' }
  end

  describe '.find' do
    subject { described_class.find(color) }
    let(:color) { "blue" }

    it 'returns a cluster instance with the associated color' do
      subject.color.should == "blue"
      subject.region.should == "us-east-1"
    end
  end

  #describe "#valid_role_transition?" do
  #  let(:cluster) { Cluster.new }
  #  let(:node) { mock Chef::Node }

  #  context "when transition to a standby node" do
  #    [ChefEnv::Role::INTERVIEW_DJ_STANDBY, ChefEnv::Role::SERVICING_DJ_STANDBY].each do |new_role|
  #      subject { cluster.valid_role_transition? ChefEnv::Role::INTERVIEW_DJ_ACTIVE, new_role }
  #      it "should always allow it for #{new_role}" do
  #        subject.should be_true
  #      end
  #      it "should allow transition to #{new_role} even when a node in standby already exists" do
  #        cluster.stub(:find_first_by_role).with(new_role).and_return node
  #        subject.should be_true
  #      end
  #    end
  #  end

  #  context "when transition to an active node" do
  #    subject { cluster.valid_role_transition? ChefEnv::Role::INTERVIEW_DJ_STANDBY, new_role }
  #    let(:new_role) { ChefEnv::Role::INTERVIEW_DJ_ACTIVE }

  #    context "and there is active node already" do
  #      before {cluster.should_receive(:find_first_by_role).with(new_role).and_return node}
  #      it {should be_false}
  #    end

  #    context "and there no active node" do
  #      before {cluster.should_receive(:find_first_by_role).with(new_role).and_return nil}
  #      it {should be_true}
  #    end
  #  end
  #end
end
