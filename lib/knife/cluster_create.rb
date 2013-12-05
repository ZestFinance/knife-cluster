require "knife/cluster/version"
require 'chef/knife'
module Chef
module Knife
  class ClusterCreate < Knife

    banner "knife cluster create color -E environment (options)"

    #with_opts :encrypted_data_bag_secret, :aws_ssh_key_id, :wait_for_it
    #with_validated_opts :environment, :base_domain, :prod, :region
    #validates :cluster_tag
    #
    #option :release,
    #       :long => "--release-tag release_tag",
    #       :description => "Default repository for all applications"

    #attr_reader :cluster

    def run
    end
  end
end
  end
