require 'rails/generators'

module Testing
  module Generators
    class ConfigureGenerator < ::Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      argument :framework_name, :type => :string, :default => "rspec"

      desc "Sets up a testing framework."

      attr_reader :app_name

      def configure_framework
        case framework_name
          when 'rspec'
            run 'rm -rf test/' # Removing test folder (not needed for RSpec)
            generate 'rspec:install'
            inject_into_file '.rspec', "--format documentation\n", :after => "--color\n"
            tweaks = File.read(find_in_source_paths('application.rb'))
            inject_into_file 'config/application.rb', tweaks + "\n", :after => "Rails::Application\n"
            gsub_file 'spec/spec_helper.rb', /check_pending/, 'maintain_test_schema'
            copy_file 'capybara.rb', 'spec/support/capybara.rb'
            gsub_file 'spec/spec_helper.rb', /config.use_transactional_fixtures = true/, "config.use_transactional_fixtures = false"
            copy_file 'database_cleaner.rb', 'spec/support/database_cleaner.rb'
            copy_file 'factory_girl.rb', 'spec/support/factory_girl.rb'
            if File.exists?('config/initializers/devise.rb')
              copy_file 'devise.rb', 'spec/support/devise.rb'
            end
          when 'devise'
            copy_file 'devise.rb', 'spec/support/devise.rb'
        end
      end

    end
  end
end
