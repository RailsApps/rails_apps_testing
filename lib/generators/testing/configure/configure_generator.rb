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
            inject_into_file '.rspec', "--require rails_helper\n", :after => "--require spec_helper\n"
            gsub_file '.rspec', /--warnings\n/, ''
            tweaks = File.read(find_in_source_paths('application.rb'))
            inject_into_file 'config/application.rb', tweaks + "\n", :after => "Rails::Application\n"
            copy_file 'capybara.rb', 'spec/support/capybara.rb'
            gsub_file 'spec/rails_helper.rb', /config.use_transactional_fixtures = true/, "config.use_transactional_fixtures = false"
            gsub_file 'spec/rails_helper.rb', /# Dir/, "Dir"
            copy_file 'database_cleaner.rb', 'spec/support/database_cleaner.rb'
            copy_file 'factory_bot.rb', 'spec/support/factory_bot.rb'
          when 'devise'
            copy_file 'spec/devise/support/devise.rb', 'spec/support/devise.rb'
            copy_file 'spec/devise/support/helpers/session_helpers.rb', 'spec/support/helpers/session_helpers.rb'
            copy_file 'spec/devise/support/helpers.rb', 'spec/support/helpers.rb'
            copy_file 'spec/devise/factories/users.rb', 'spec/factories/users.rb'
            copy_file 'spec/devise/models/user_spec.rb', 'spec/models/user_spec.rb'
            copy_file 'spec/devise/features/users/sign_in_spec.rb', 'spec/features/users/sign_in_spec.rb'
            copy_file 'spec/devise/features/users/sign_out_spec.rb', 'spec/features/users/sign_out_spec.rb'
            copy_file 'spec/devise/features/users/user_delete_spec.rb', 'spec/features/users/user_delete_spec.rb'
            copy_file 'spec/devise/features/users/user_edit_spec.rb', 'spec/features/users/user_edit_spec.rb'
            copy_file 'spec/devise/features/users/user_index_spec.rb', 'spec/features/users/user_index_spec.rb'
            copy_file 'spec/devise/features/users/user_show_spec.rb', 'spec/features/users/user_show_spec.rb'
            copy_file 'spec/devise/features/visitors/sign_up_spec.rb', 'spec/features/visitors/sign_up_spec.rb'
          when 'omniauth'
            copy_file 'spec/omniauth/support/helpers/omniauth.rb', 'spec/support/helpers/omniauth.rb'
            copy_file 'spec/omniauth/support/helpers.rb', 'spec/support/helpers.rb'
            copy_file 'spec/omniauth/features/users/sign_in_spec.rb', 'spec/features/users/sign_in_spec.rb'
            copy_file 'spec/omniauth/features/users/sign_out_spec.rb', 'spec/features/users/sign_out_spec.rb'
            copy_file 'spec/omniauth/controllers/sessions_controller_spec.rb', 'spec/controllers/sessions_controller_spec.rb'
            copy_file 'spec/omniauth/factories/users.rb', 'spec/factories/users.rb'
            copy_file 'spec/omniauth/models/user_spec.rb', 'spec/models/user_spec.rb'
          when 'pundit'
            copy_file 'spec/pundit/factories/users.rb', 'spec/factories/users.rb'
            copy_file 'spec/pundit/features/users/user_index_spec.rb', 'spec/features/users/user_index_spec.rb'
            copy_file 'spec/pundit/policies/user_policy_spec.rb', 'spec/policies/user_policy_spec.rb'
            copy_file 'spec/pundit/support/pundit.rb', 'spec/support/pundit.rb'
        end
      end

    end
  end
end
