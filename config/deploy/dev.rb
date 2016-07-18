server 'discovery-dispatcher-dev.stanford.edu', user: fetch(:user), roles: %w{web db app}
set :bundle_without, %w(sqlite test deployment).join(' ')

Capistrano::OneTimeKey.generate_one_time_key!
set :rails_env, 'development'