$:.unshift File.expand_path('../../knife', __FILE__)
Bundler.require :default, :test
require "chef/knife/cluster_create"
require 'support/shared_examples/knife_examples'

ENV['aws_access_key_id']='12345'
ENV['aws_secret_access_key']='12345'

Fog.mock!

PROJECT_ROOT = "#{File.dirname(__FILE__)}/.."
Chef::Config[:data_bag_path] = "#{PROJECT_ROOT}/spec/data_bags"
Chef::Config[:cookbook_path] = "#{PROJECT_ROOT}/cookbooks"
Chef::Config[:node_name] = "some_name"
Chef::Config[:encrypted_data_bag_secret] = File.expand_path("#{PROJECT_ROOT}/spec/support/databag.key")
Chef::Config[:solo] = true

RSpec.configure do |config|
  #config.before(:suite) do
  #  WebMock.disable_net_connect!
  #end
  config.after(:each) do
    Chef::Config[:environment] = nil
  end
end

#SimpleCov.start do
#  add_filter "/vendor/"
#end
