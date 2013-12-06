require 'chefspec/matchers/shared'

##
# apache cookbook uses a2ensite command to enable a site,
# so here is the matcher for it
module ChefSpec
  RSpec::Matchers.define :enable_site do |name|
    match do |chef_run|
      chef_run.execute("a2ensite #{name}.conf")
    end
  end

  RSpec::Matchers.define :create_site do |name|
    match do |chef_run|
      file = "/etc/apache2/sites-available/#{name}.conf"
      chef_run.template(file) and chef_run.execute("a2ensite #{name}.conf")
    end
  end
end
