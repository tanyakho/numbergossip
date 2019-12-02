FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
ENV RAILS_ENV=production

RUN apt-get update
RUN apt-get install -y gnupg apt-transport-https ca-certificates

# Install Ruby, Apache and Passenger, Sqlite3 headers, and Nokogiri dependencies
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
RUN echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list
RUN apt-get update
RUN apt-get install -y build-essential tzdata \
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

# Let Rails read the master key file
RUN chmod 0644 config/master.key

# Precompile the assets
RUN bundle exec rails assets:precompile

# Build the production database
RUN bundle exec rails db:schema:load
RUN bundle exec rails rebuild_database

# Make sure the log files exist
RUN touch log/development.log log/production.log

# Make logs, site location, assets, and the database read-write by
# Apache and Rails (there are no other users to protect from)
RUN chmod -R 0777 log/ public/ db/

# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
CMD ["apachectl", "-D", "FOREGROUND"]
