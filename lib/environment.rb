class Environment
  class << self
    def all
      {
          # Make sure these are all lowercase
          'development' => { prefix: 'd' },
          'staging'     => { prefix: 's' },
          'qa'          => { prefix: 'q' },
          'production'  => { prefix: 'p' }
      }
    end

    def chef_env_to_rails_env(chef_env)
      case chef_env
        when 'production'  then 'production'
        when 'qa'          then 'qa'
        when 'staging'     then 'staging'
        when 'development' then 'staging'
      end
    end

    def rails_environments
      ['production', 'qa', 'staging', 'development']
    end
  end
end