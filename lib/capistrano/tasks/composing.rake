namespace :composing do
    # 初始化时建立所有镜像
    desc "build application images"
    task :build do
        on roles(:app) do
            within current_path do
                execute("docker-compose", 
                    "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                    "-f", "docker-compose.#{fetch(:stage)}.yml", "build")
            end
        end

    end
    
    #停止所有的镜像 
    desc "take down compose application containers"
    task :down do
        on roles(:app) do
            within current_path do
                execute("docker-compose", "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                    "-f", "docker-compose.#{fetch(:stage)}.yml", "down")
            end
        end
    end

    # docker-compose --project-name=p_yam_production -f docker-compose.production.yml build


    #当重新部署后，重启应用的容器，只重启rails app,其他相关服务如sql和redis容器都不重新启动
    namespace :restart do
        desc "Rebuild and restart app container"
        task :app do
            on roles(:app) do
                within current_path do
                    execute("docker-compose", "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                        "-f", "docker-compose.#{fetch(:stage)}.yml", "build", "app")
                    # execute("docker-compose", "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                    #     "-f", "docker-compose.#{fetch(:stage)}.yml",
                    #     "up", "-d", "--no-deps", "app")
                    execute("docker-compose", "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                        "-f", "docker-compose.#{fetch(:stage)}.yml",
                        "up", "--no-deps", "app")
                end
            end
        end
    end

    namespace :redis do
        desc "up redis "
        task :up do
            on roles(:app) do
                execute("docker-compose",
                "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                "-f", "docker-compose.#{fetch(:stage)}.yml",
                "up", "--no-deps", "redis"
            )
            end
        end
    end

    namespace :nginx do
        desc "up nginx"
        task :up do
            on roles(:app) do
                execute("docker-compose",
                "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                "-f", "docker-compose.#{fetch(:stage)}.yml",
                "up", "--no-deps", "web"
            )
            end
        end
    end

    namespace :database do

        desc "Up database and make sure it's ready"
        task :up do
          on roles(:app) do
            within current_path do
              # execute("docker-compose",
              #   "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
              #   "-f", "docker-compose.#{fetch(:stage)}.yml",
              #   "up", "-d", "--no-deps", "mysql"
              # )
              execute("docker-compose",
                "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                "-f", "docker-compose.#{fetch(:stage)}.yml",
                "up", "--no-deps", "mysql"
              )
            end
          end
          sleep 5
        end



        desc "Create database"
        task :create do
            on roles(:app) do
                within current_path do
                    execute("docker-compose",
                        "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                        "-f", "docker-compose.#{fetch(:stage)}.yml",
                        "run", "--rm", "app", "rake", "db:create"
                    )
                end
            end
        end
        
        task :migrate do
        desc "migrate database"
            on roles(:app) do
                within current_path do 
                    execute("docker-compose",
                        "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                        "-f", "docker-compose.#{fetch(:stage)}.yml",
                        "run", "--rm", "app", "rake", "db:migrate"
                    )
                end
            end
        end
    end

end
