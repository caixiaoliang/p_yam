# config valid only for current version of Capistrano

lock "3.8.0"

server '106.14.251.102', roles: [:web, :app, :db], primary: true

set :application, "p_yam"

set :repo_url,        'git@github.com:caixiaoliang/p_yam.git'
set :application,     'p_yam'
set :scm,           :git
set :pty,             true
set :use_sudo,        false
set :stage,           :production
set :deploy_via,      :remote_cache
set :deploy_to,       "/home/colony/#{fetch(:application)}"

# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :ssh_options,     {user: fetch(:user)}
# set :password, "xiaoliang"

set :keep_releases, 1

namespace :deploy do

  desc "Initialize application"
  task :initialize do
    invoke 'composing:build'
    invoke 'composing:database:create'
    invoke 'composing:database:migrate'
  end

  after :published, :restart do
    invoke 'composing:restart:web'
    invoke 'composing:database:migrate'
  end

  before :finished, :clear_containers do
    on roles(:app) do
      execute "docker ps -a -q -f status=exited | xargs -r docker rm -v"
      execute "docker images -f dangling=true -q | xargs -r docker rmi -f"
    end
  end

  after :publishing, 'deploy:build'
  after :publishing, 'deploy:restart'
end