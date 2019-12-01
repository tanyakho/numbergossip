FROM ruby:2.6.5
ENV RAILS_ENV production

# Install gems
RUN gem install bundler -v 2.0.2
ADD Gemfile* /app/
WORKDIR /app
RUN bundle install --without development test

# Install Apache
RUN apt-get update
RUN apt-get install -y apache2 libapache2-mod-fcgid

# Load the app code
ADD . /app

# Configure Apache
RUN ln -s /app/deploy/vhost.conf /etc/apache2/sites-enabled/
RUN a2enmod rewrite  # Enable RewriteEngine
# Flush default virtual host so it doesn't hijack requests
RUN rm /etc/apache2/sites-enabled/000-default.conf

# RUN RAILS_GROUPS=assets bundle exec rake assets:precompile
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
CMD ["apachectl", "-D", "FOREGROUND"]
