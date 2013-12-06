require "spec_helper"

describe ClusterConfig do
  describe ".env_config" do
    it "returns a hash" do
      config = described_class.env_config("staging")
      config.should be_a Hash
      config.should_not be_empty
    end

    context "invalid environment" do
      it "returns an empty hash" do
        described_class.env_config("invalid").should be_empty
      end
    end
  end
end
