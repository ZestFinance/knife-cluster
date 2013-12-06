module Zest
  module Bork
    class Spec
      module CronFinder
        def cron(name)
          find_resource('cron', name) # find_resource is private!
        end
      end

      module ExecuteFinder
        def execute(name)
          find_resource('execute', name)
        end
      end

      module UserFinder
        def user(name)
          find_resource('user', name)
        end
      end
    end
  end
end

class ChefSpec::ChefRunner
  include Zest::Bork::Spec::CronFinder
  include Zest::Bork::Spec::ExecuteFinder
  include Zest::Bork::Spec::UserFinder
end
