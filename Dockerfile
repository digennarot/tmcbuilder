FROM ruby

LABEL maintainer="tiziano.digennaro@abc.com"
LABEL version="0.1"
LABEL description="fpm docker image"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y ruby-dev rubygems build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
RUN gem install fpm

WORKDIR /var/tmp
COPY Makefile /var/tmp

CMD ["make", "-C", "/var/tmp"]
