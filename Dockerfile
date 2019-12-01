FROM ruby:2.6.5
ENV RAILS_ENV production
RUN gem install bundler -v 2.0.2
ADD Gemfile* /app/
WORKDIR /app
RUN bundle install --without development test
ADD . /app
# RUN RAILS_GROUPS=assets bundle exec rake assets:precompile
