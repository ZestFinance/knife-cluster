require 'environment'
require 'cluster_helper'

class Cluster
  include ClusterHelper
  attr_reader :color, :environment, :region, :base_domain
  attr_accessor :cluster_databag

  DATABAG_NOTFOUND = [
      Net::HTTPServerException,
      Chef::Exceptions::ValidationFailed
  ]

  def initialize(opts = {})
    @color = opts[:color]
    @environment = opts[:environment]
    @region = opts[:region]
    @base_domain = opts[:base_domain]
  end

  def self.find(arg, opts={})
    color = opts[:color]
    environment = nil
    if Environment.all.has_key?(arg)
      environment = arg
      color ||= color_from_env(environment)
    else
      color ||= arg
      environment = opts[:environment] || env_from_color(color)
    end

    data_bag = find_data_bag(color, environment)

    if data_bag
      region = data_bag['region']
      base_domain = data_bag['base_domain']
    end

    if color && environment
      Cluster.new(color: color, environment: environment, region: region, base_domain: base_domain)
    end
  end

  private

  def self.color_from_env(environment)
    name_helper = Zest::DnsNameHelper.new(rails_env(environment), "spotloan.com")
    raise "Names for #{rails_env(environment)} do not point to a single color: #{name_helper.colors.join(", ")}" unless name_helper.all_one_color?
    name_helper.colors.first
  end

  def self.find_data_bag(color, environment = nil)
    data_bags = []
    environments = environment.nil? ? Environment::rails_environments : [environment]
    environments.each do |e|
      begin
        data_bags << Chef::DataBagItem.load("#{e}_cluster", color)
      rescue *DATABAG_NOTFOUND
      end
    end

    if data_bags.count > 1
      raise "Ambiguous color #{color}. Present in these envs: #{environments.join(", ")}"
    end

    data_bags.first
  end
end

