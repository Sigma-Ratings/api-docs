FROM ruby:2.6-slim as build

WORKDIR /srv/slate

VOLUME /srv/slate/source
EXPOSE 4567

COPY . /srv/slate

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        nodejs \
    && gem install bundler \
    && bundle install \
    && apt-get remove -y build-essential \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
   && bundle exec middleman build --clean --verbose --build-dir=/srv/slate./build-output

FROM scratch as build-output
COPY --from=build /srv/slate/build-output . 

