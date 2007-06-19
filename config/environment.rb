# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
#ENV['RAILS_ENV'] ||= 'production'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
  # config.frameworks -= [ :action_web_service, :action_mailer ]
  # config.frameworks -= [ :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
  
  # See Rails::Configuration for more options
end

# Configure the ActionMailer
ActionMailer::Base.smtp_settings = {
  :address => "127.0.0.1",
	:domain => "assembly.org",
	:authentication => "plain",
  :port => 25,
}

# Start the LoginEngine
#module LoginEngine
#  config :salt, "elaine-2006-rocks"
#  config :use_email_notification, true
#  config :confirm_account, true
#  config :email_from, "mikael.lavi@assemblytv.net"
#end

#Engines.start :login

# Start the UserEngine

#module UserEngine
#  config :admin_login, "admin"
#  config :admin_email, "mikael.lavi@assemblytv.net"
#  config :admin_password, "nk4bH7d"
#end

#Engines.start :user
#UserEngine.check_system_roles

# Start the MenuEngine
#module MenuEngine
#  config :access_control, true
#  config :on_show, "new Effect.Appear( element, { duration: 0.2, from:0.0, to: 1.0 } );"
#  config :on_hide, "new Effect.Fade( element, { duration: 0.2 });"
#end

#Engines.start :menu

# Add new inflection rules using the following format 
# (all these examples are active by default):
# Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# Include your application configuration below
TEST_SETTING = "joo"