FROM ruby:2.5.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client cmake

RUN mkdir -p $RAILS_ROOT/tmp/pids

ENV RAILS_ROOT /usr/src/app
ENV RAILS_ENV production
ENV PORT 3000

ENV BUNDLE_PATH "/.bundle"
ENV BUNDLE_BIN "/.bundle/bin"
ENV GEM_HOME "/.bundle"
ENV PATH "${BUNDLE_BIN}:${PATH}"

COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

WORKDIR $RAILS_ROOT

RUN gem install bundler

COPY Gemfile Gemfile.lock ./

ENTRYPOINT ["/docker-entrypoint.sh"]

COPY anycable-go /
RUN chmod +x /anycable-go

CMD puma -C config/puma.rb

EXPOSE $PORT
