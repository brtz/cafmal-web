FROM ruby:2.4-alpine
MAINTAINER Nils Bartels <n.bartels@bigpoint.net>

ENV APP_HOME /cafmal-web
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# on alpine we need to create www-data
RUN set -x \
    && addgroup -g 82 -S www-data \
    && adduser -u 82 -D -S -G www-data www-data

# unfortunately we need native extensions, so compilers
RUN apk add --update build-base ca-certificates linux-headers nodejs ruby-dev tini
RUN update-ca-certificates

ADD Gemfile $APP_HOME/
ADD Gemfile.lock $APP_HOME/
RUN bundle install --clean

# remove apk packages again
RUN apk del --purge build-base linux-headers ruby-dev
ADD . $APP_HOME

# chown files for www-data write access. webserver needs Gemfile.lock
RUN chown -R www-data:www-data Gemfile.lock log/ public/ tmp/

USER www-data

RUN bundle exec rake assets:precompile

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["puma", "-b", "tcp://0.0.0.0:3000"]