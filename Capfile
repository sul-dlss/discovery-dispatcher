# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/bundler'
require 'dlss/capistrano'
require 'whenever/capistrano'
require 'capistrano/passenger'
require 'capistrano/sidekiq'
require 'capistrano/rails/migrations'
require 'capistrano/rvm'
require 'capistrano/honeybadger'
# load 'deploy/assets'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
