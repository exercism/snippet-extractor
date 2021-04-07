FROM ruby:2.6.6-alpine3.12

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN gem install bundler -v 2.1.4

WORKDIR /opt/snippet-extractor

COPY . .

RUN bundle install

ENTRYPOINT ["sh", "/opt/snippet-extractor/bin/run.sh"]
