# config valid only for current version of Capistrano
lock "3.7.2"

# set :repo_url, "https://github.com/caixiaoliang/p_yam"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5
server '106.14.251.102', roles: [:web, :app, :db], primary: true

set :application, "p_yam"

set :repo_url,        'git@github.com:caixiaoliang/p_yam.git'
set :application,     'p_yam'
set :user,            'deploy'
set :puma_threads,    [4, 16]
set :puma_workers,    0

# Don't change these unless you know what you're doing
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.error.log"
set :puma_error_log,  "#{release_path}/log/puma.access.log"
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :ssh_options,     {user: fetch(:user)}

set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true  # Change to false when not using ActiveRecord
set :password, "xiaoliang"
## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

before "deploy:migrate",     "db:default"
after  "deploy:finishing",    :compile_assets
after  "deploy:finishing",    :cleanup

namespace :db do
  desc 'Create database yml in shared_path'
  task :default do
    on roles(:web) do
      puts "start generate database.yml xxxxxxxxx"
      db_config = ERB.new <<-EOF
        base: &base
          host: localhost
          adapter: mysql2
          encoding: utf8
          reconnect: false
          pool: 5
          username: #{fetch(:user)}
          password: xiaoliang

        development:
          database: #{fetch(:application)}_dev
          <<: *base
        test:
          database: #{fetch(:application)}_test
          <<: *base

        production:
          database: #{fetch(:application)}_prod
          <<: *base

      EOF
      
      p (a = db_config.result.gsub("\n","\\n"))
      execute "mkdir -p #{shared_path}/config"
      execute "touch /home/deploy/apps/p_yam/shared/config/database_tmp.yml"
      execute "echo  -e '#{a}' >> #{shared_path}/config/database_tmp.yml"
      execute "mv #{shared_path}/config/database_tmp.yml #{shared_path}/config/database.yml"
      execute "cp #{shared_path}/config/database.yml  #{release_path}/config/database.yml"

      execute "cat #{shared_path}/config/database.yml"
      puts "generate database.yml successfully"
    end
  end

  desc "Make symlink for database yml"
  task :symlink do
    on roles(:web) do
      puts "enter in symlink"
      execute "ln -fs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end
end

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:web) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end




# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
