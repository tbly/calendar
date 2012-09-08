# Compile assets in prod env. on deploy and before restart
load 'deploy/assets'
set :whenever_environment, defer { stage }
require "whenever/capistrano"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_type, :system  # Copy the exact line. I really mean :system here

require 'rvm/capistrano'
require 'bundler/capistrano'
require 'database_yml/capistrano'

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "icnow2"
set :user, "deploy"
set :group, "deploy"

set :scm, :git
set :repository, "git@github.com:brycem/icnow2.git"
set :deploy_to, "/opt/sites/#{application}"
set :deploy_via, :remote_cache
set :deploy_env, 'production'

namespace :deploy do
  task :restart, :roles => :web do
    run "touch #{ current_path }/tmp/restart.txt"
  end
end

namespace :custom do
  task :symlink do
    run "ln -nfs #{shared_path}/movie_files #{release_path}/lib/assets/movie_files"
  end
end

after "deploy:finalize_update", "custom:symlink"
