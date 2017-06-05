# config valid only for current version of Capistrano

lock "3.8.1"

server '106.14.251.102', roles: [:web, :app, :db], primary: true

set :application, "p_yam"

set :repo_url,        'git@github.com:caixiaoliang/p_yam.git'
set :application,     'p_yam'
set :user,            'deploy'
set :branch,        :docker_master

set :pty,             true
set :use_sudo,        false
set :stage,           :production
# set :deploy_via,      :remote_cache
set :deploy_to,       "/home/#{fetch(:user)}/docker-apps/#{fetch(:application)}"

# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
set :ssh_options,     {user: fetch(:user)}
set :password, "xiao"

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
      execute("docker ps -a -q  -f status=running | xargs -r docker stop")
      execute "docker ps -a -q -f status=exited | xargs -r docker rm -v"
      execute "docker images -f dangling=true -q | xargs -r docker rmi -f"
    end
  end

end