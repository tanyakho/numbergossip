FROM ubuntu:18.04
ENV DEBIAN_FRONTEND=noninteractive
ENV RAILS_ENV=production

RUN apt-get update
RUN apt-get install -y gnupg apt-transport-https ca-certificates

# Install Ruby, Apache, Passenger, Sqlite3 headers, and Nokogiri and mimemagic dependencies
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys 561F9B9CAC40B2F7
RUN echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main \
    > /etc/apt/sources.list.d/passenger.list
RUN apt-get update
RUN apt-get install -y build-essential tzdata \
    libssl-dev ruby ruby-dev \
    apache2 \
    passenger libapache2-mod-passenger \
    libsqlite3-dev \
    patch zlib1g-dev liblzma-dev shared-mime-info

# Install gems
RUN gem install bundler -v 2.0.2
ADD Gemfile* /app/
WORKDIR /app
RUN bundle install --without development test

# Flush default virtual host so it doesn't hijack requests
RUN rm /etc/apache2/sites-enabled/000-default.conf

# Load the app code
ADD . /app

# Install Apache configuration
RUN ln -s /app/deploy/numbergossip-apache.conf /etc/apache2/sites-enabled/

# Let Rails read the master key file, if present
# It will typically be present during development, but not production
RUN if [ -e config/master.key ]; then chmod 0644 config/master.key; fi

# Precompile the assets
RUN bundle exec rails assets:precompile

# Build the production database
RUN bundle exec rails db:schema:load
RUN bundle exec rails rebuild_database

# Make sure the log files exist
RUN touch log/development.log log/production.log

# Make logs, site location, assets, and the database read-write by
# Apache and Rails, regardless of what user they run as (there are no
# other users to protect from)
RUN chmod -R 0777 log/ public/ db/

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]
