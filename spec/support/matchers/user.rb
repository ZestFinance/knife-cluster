require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:create, :delete], [:user], :name)
  end
end
