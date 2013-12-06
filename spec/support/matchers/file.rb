require 'chefspec/matchers/shared'

module ChefSpec
  RSpec::Matchers.define :render_template_with_content do |file, matcher|
    match do |chef_run|
      template = chef_run.template(file)
      rendered_content = render(template, chef_run.node)

      if matcher.is_a? Regexp
        rendered_content =~ matcher
      else
        rendered_content == matcher
      end
    end
  end

  RSpec::Matchers.define :have_mode do |mode|
    match do |file|
      file.mode == mode
    end
  end

  RSpec::Matchers.define :be_with_recursive_option do
    match do |file|
      file.recursive == true
    end
  end

  RSpec::Matchers.define :be_without_recursive_option do
    match do |file|
      file.recursive == false
    end
  end
end
