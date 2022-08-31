FROM ruby:2.2.2
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN mkdir /gradready
WORKDIR /gradready
ADD Gemfile /gradready/Gemfile
RUN bundle install
ADD . /gradready
EXPOSE 3000

