FROM ruby

LABEL maintainer="tiziano.digennaro@aciworldwide.com"
ARG version
LABEL version="${version}"
ENV version="${version}"
LABEL description="fpm docker for tomcat builder"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

RUN echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null

RUN apt-get update
RUN apt-get install -y ruby-dev rubygems build-essential && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
RUN gem install fpm

WORKDIR /var/tmp
COPY Makefile /var/tmp

CMD ["make", "PKG_RELEASE=${version}", "-C", "/var/tmp"]
