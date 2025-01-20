# syntax=docker/dockerfile:1
FROM ruby:3.1.2-slim

WORKDIR /rails

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client build-essential git libpq-dev pkg-config libzmq3-dev && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    npm install --global yarn && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN gem update --system
RUN gem install bundler -v 2.5.20
RUN bundle config set frozen false

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install

# Chart.js 설치
RUN yarn add chart.js

# (부트스냅 precompile / assets:precompile 제거)
COPY . .

# Development 환경에서는 production asset precompile 안 함
CMD ["bundle", "exec", "rails", "server", "-p", "3333", "-b", "0.0.0.0"]
