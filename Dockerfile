FROM ubuntu
MAINTAINER Niall O'Higgins <niallo@frozenridge.co>

RUN apt-get update

RUN apt-get install -y \
  curl \
  wget \
  make \
  build-essential \
  libssl-dev \
  python \
  python-dev \
  git \
  default-jre-headless

RUN locale-gen en_US en_US.UTF-8
RUN mkdir -p /data/db

RUN curl -L https://raw.github.com/isaacs/nave/master/nave.sh > /bin/nave \
 && chmod a+x /bin/nave

RUN nave usemain stable

ADD ./package.json /src/package.json
RUN cd /src \
 && npm install

ADD . /src
WORKDIR /src
ENTRYPOINT ["docker/start-strider.sh"]

EXPOSE 3000
