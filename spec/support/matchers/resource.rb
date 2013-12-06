require 'chefspec/matchers/shared'

module ChefSpec
  RSpec::Matchers.define :have_resource_attributes do |expected_opts|
    match do |resource|
      expected_opts.all? do |k,v|
        if v.is_a? Regexp
          resource.send(k) =~ v
        else
          resource.send(k) == v
        end
      end
    end
  end
end