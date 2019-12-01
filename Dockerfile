FROM ruby:2.6.5
ENV RAILS_ENV production
RUN gem install bundler -v 2.0.2
ADD Gemfile* /app/
WORKDIR /app
RUN bundle install --without development test
RUN apt-get update
RUN apt-get install -y apache2
ADD . /app
RUN ln -s /app/deploy/vhost.conf /etc/apache2/sites-enabled/
# RUN RAILS_GROUPS=assets bundle exec rake assets:precompile
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
CMD ["apachectl", "-D", "FOREGROUND"]
