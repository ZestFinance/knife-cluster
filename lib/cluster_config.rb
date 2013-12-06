require "yaml"

module ClusterConfig
  extend self

  def env_config(environment, options = {})
    options = default.merge(options)
    config_file = "#{base_path}/config/#{options[:region]}/#{options[:domain]}/#{environment}.yml"
    if File.exists?(config_file)
      config = YAML.load(IO.read(config_file))
    end

    config || {}
  end

  def default
    @@default ||= {
        region: "us-east-1",
        domain: ""
    }
  end

  def base_path
    @@base_path ||= File.expand_path(File.dirname(File.dirname(__FILE__)))
  end
end
