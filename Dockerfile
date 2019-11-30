FROM ruby:2.6.5
ENV RAILS_ENV production
ADD Gemfile* /app/
WORKDIR /app
RUN bundle install --without development test
ADD . /app
RUN RAILS_GROUPS=assets bundle exec rake assets:precompile
