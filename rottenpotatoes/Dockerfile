FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir /rottenpotatoes
WORKDIR /rottenpotatoes

COPY Gemfile /rottenpotatoes/Gemfile
COPY Gemfile.lock /rottenpotatoes/Gemfile.lock
RUN bundle install

COPY . /rottenpotatoes