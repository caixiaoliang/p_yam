FROM ruby:2.3

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs locales imagemagick vim

# Use en_US.UTF-8 as our locale

RUN locale-gen en_US.UTF-8 

# 设置环境变量，即在后面可以用 $RAILS_ROOT
# 来指代容器中的 rails 程序放的目录
ENV RAILS_ROOT /var/www/p_yam

ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8
ENV MYSQL_ROOT_PASSWORD "xiaoliang"

ENTRYPOINT ["bundle", "exec"]


RUN mkdir -p $RAILS_ROOT
# 设置容器里的工作目录
WORKDIR $RAILS_ROOT


# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.

# 备份 Gemfile 及 lock到容器的工作目录中
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler && bundle install --jobs 20 --retry 5


COPY config/containers/puma.rb config/containers/puma.rb

# Copy the main application.
COPY . ./

EXPOSE 3000


CMD bundle exec puma -C config/containers/puma.rb
#CMD ["rails", "server", "-b", "0.0.0.0"]


