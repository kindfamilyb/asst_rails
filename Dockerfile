# syntax=docker/dockerfile:1
FROM ruby:3.4.1

WORKDIR /rails

# Node 모듈 바이너리가 우선 검색되도록 PATH 수정
ENV PATH="/rails/node_modules/.bin:$PATH"


RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips postgresql-client build-essential \
      git libpq-dev pkg-config libzmq3-dev \
    && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y \
#       curl libjemalloc2 libvips postgresql-client build-essential \
#       git libpq-dev pkg-config libzmq3-dev && \
#     curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
#     # apt-get install -y nodejs && \
#     # npm install --global yarn && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

RUN gem update --system
RUN gem install bundler -v 2.5.20
RUN bundle config set frozen false

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# Development 환경에서는 production asset precompile 안 함
CMD ["bundle", "exec", "rails", "server", "-p", "3333", "-b", "0.0.0.0"]
