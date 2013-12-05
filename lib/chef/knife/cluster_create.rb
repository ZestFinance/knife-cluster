require "knife-cluster/version"
require 'chef/knife'

class Chef
  class Knife
    class ClusterCreate < Knife

      banner "knife cluster create color -E environment (options)"
      OPTS = {
        :aws_access_key_id => {
          :short => "-A ID",
          :long => "--aws-access-key-id KEY",
          :description => "Your AWS Access Key ID",
          :proc => Proc.new { |key| Chef::Config[:knife][:aws_access_key_id] = key }
        },
        :aws_secret_access_key => {
          :short => "-K SECRET",
          :long => "--aws-secret-access-key SECRET",
          :description => "Your AWS API Secret Access Key",
          :proc => Proc.new { |key| Chef::Config[:knife][:aws_secret_access_key] = key }
        },
        :cluster_tag => {
          :short => "-t TAG",
          :long => "--cluster-tag TAG",
          :description => "Tag that identifies this node as part of the <TAG> cluster"
        },
        :environment => {
          :short => "-E CHEF_ENV",
          :long => "--environment CHEF_ENV",
          :description => ""
        },
        :region => {
              :long => "--region REGION",
              :short => '-R REGION',
              :description => "Your AWS region, i.e. 'us-east-1' or 'us-west-1'",
              :default => "us-east-1",
              :proc => Proc.new { |key| Chef::Config[:knife][:region] = key }
          },
        :prod => {
              :long => "--prod",
              :description => "If the environment for your command is production, you must also pass this parameter.  This is to make it slightly harder to do something unintentionally to production."
        }
      }

      def self.with_opts(*args)
        invalid_args = args.select {|arg| !OPTS.keys.include? arg }
        raise "Invalid option(s) passed to with_opts: #{invalid_args.join(", ")}" unless invalid_args.empty?

        args.each do |arg|
          option arg, OPTS[arg]
        end
      end

      def self.with_validated_opts(*args)
        #with_opts(*args)
        #validates(*args)
      end

      def self.validates(*args)
        #raise "Invalid argument(s) passed to validates: #{args - VALIDATORS.keys}" unless (args - VALIDATORS.keys).empty?
        #self.validated_opts ||= []
        #self.validated_opts.concat args
      end

      with_opts :environment, :region
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
