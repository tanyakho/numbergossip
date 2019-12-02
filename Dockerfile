FROM ubuntu:18.04
ENV RAILS_ENV production

RUN apt-get update
RUN apt-get install -y gnupg apt-transport-https ca-certificates

# Install Ruby, Apache and Passenger, Sqlite3 headers, and Nokogiri dependencies
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list
RUN apt-get update
RUN apt-get install -y build-essential \
  libssl-dev ruby ruby-dev \
  apache2 passenger libapache2-mod-passenger \
  libsqlite3-dev \
  patch zlib1g-dev liblzma-dev

# Install gems
RUN gem install bundler -v 2.0.2
ADD Gemfile* /app/
WORKDIR /app
RUN bundle install --without development test

# Load the app code
ADD . /app

# Configure Apache
RUN ln -s /app/deploy/vhost.conf /etc/apache2/sites-enabled/
# Flush default virtual host so it doesn't hijack requests
RUN rm /etc/apache2/sites-enabled/000-default.conf

# RUN RAILS_GROUPS=assets bundle exec rake assets:precompile
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
CMD ["apachectl", "-D", "FOREGROUND"]
