namespace :composing do
    # 建立所有镜像
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


    #当重新部署后，重启应用的容器，相关服务如sql和redis容器不动
    namespace :restart do
        desc "Rebuild add restart web container"
        task :web do
            on roles(:app) do
                within current_path do
                    execute("docker-compose", "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                        "-f", "docker-compose.#{fetch(:stage)}.yml", "build", "web")
                    execute("docker-compose", "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                        "-f", "docker-compose.#{fetch(:stage)}.yml",
                        "up", "-d", "--no-deps", "web")
                end
            end
        end
    end


    namespace :database do
        desc "Create database"
        task :create do
            on roles(:app) do
                within current_path do
                    # execute("docker-compose",
                    #     "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                    #     "-f", "docker-compose.#{fetch(:stage)}.yml",
                    #     "run", "--rm", "web", "rake", "db:create"
                    # )
                end
            end
        end
        
        task :migrate do
        desc "migrate database"
            on roles(:app) do
                within current_path do 
                    # execute("docker-compose",
                    #     "--project-name=#{fetch(:application)}_#{fetch(:stage)}",
                    #     "-f", "docker-compose.#{fetch(:stage)}.yml",
                    #     "run", "--rm", "web", "rake", "db:migrate"
                    # )
                end
            end
        end
    end

end
