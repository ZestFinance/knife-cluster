require "knife-cluster/version"
require 'chef/knife'
require 'cluster'
require 'zestknife'

class Chef
  class Knife
    class ClusterCreate < ::ZestKnife

      banner "knife cluster create color -E environment (options)"
      with_opts :encrypted_data_bag_secret, :aws_ssh_key_id
      with_validated_opts :environment, :base_domain, :region
      validates :cluster_tag

      option :release,
             :long => "--release-tag release_tag",
             :description => "Default repository for all applications"

      attr_reader :cluster

      def run
        $stdout.sync = true
        setup_config

        @cluster     = Cluster.find(name_args.first, environment: config[:environment])
        @environment, @color = cluster.environment, cluster.color
        @base_domain = config[:base_domain]
        @release_tag = config[:release]
        @region      = config[:region]

        databag = confirm_or_prompt_for_databag
        validate!



      end

      private

      def confirm_or_prompt_for_databag
        databag = cluster.cluster_databag || create_cluster_databag

        #make sure region exist for existing databags that don't have it
        databag['region'] = config[:region] unless databag[:region]

        Cluster::ALL_APPS.each do |app|
          unless databag[app] && databag[app]['revision']
            rev = ask_question("Deploy branch for #{app} #{"(defaults to #{default_revision})" if default_revision}")
            rev = rev.empty? ? default_revision : rev
            databag[app] = {'revision' => rev}
          end
          databag[app]['db'] = {}
        end

        # HACK: so the memoized cluster_databag returns the right thing
        cluster.cluster_databag = databag if databag.save
      end

      def create_cluster_databag
        item = Chef::DataBagItem.new
        item['id'] = @color
        item['region'] = @region
        item['base_domain'] = @base_domain
        item['environment'] = @environment
        item.data_bag(cluster_databag_name @environment)
        item.save
      end

      def cluster_databag_name chef_env
        "#{::Environment.chef_env_to_rails_env(chef_env)}_cluster"
      end

      REVISION_BY_ENV = {
          'production'  => 'master',
          'development' => 'develop',
          'staging'     => 'develop'
      }

      def default_revision
        @release_tag || REVISION_BY_ENV[@environment]
      end

      def validate!
        unless File.exists?(config[:encrypted_data_bag_secret])
          errors << "Could not find encrypted data bag secret. Tried #{config[:encrypted_data_bag_secret]}"
        end

        super([:aws_access_key_id, :aws_secret_access_key, :aws_ssh_key_id])
      end

    end
  end
end
