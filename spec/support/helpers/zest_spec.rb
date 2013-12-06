module Zest
  module Bork
    class Spec
      def self.chef_runner
        ChefSpec::ChefRunner.new(:cookbook_path => Chef::Config[:cookbook_path], :log_level => :error) do |node|
          set_default_attributes_on node
        end
      end

      def self.set_default_attributes_on node
        cluster_color = {'cluster' => {'color' => 'solo'}}
        cpu_total = {'total' => '8'}
        lsb_codename = {'codename' => 'lucid'}
        node.set['rails'] = cluster_color
        node.set['assigned_hostname'] = 'test_node'
        node.set['cpu'] = cpu_total
        node.set['lsb'] = lsb_codename
      end
    end
  end
end
