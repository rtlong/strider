FROM ubuntu
MAINTAINER Niall O'Higgins <niallo@frozenridge.co>

RUN echo "deb http://archive.ubuntu.com/ubuntu quantal main universe" > /etc/apt/sources.list.bak \
 && echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/10gen.list \
 && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 \
 && apt-get update

RUN apt-get install -y \
  curl \
  wget \
  make \
  build-essential \
  libssl-dev \
  python \
  python-dev \
  git \
  default-jre-headless \
  mongodb-10gen \
  nodejs \
  npm

RUN locale-gen en_US en_US.UTF-8
RUN mkdir -p /data/db

RUN curl https://raw.github.com/isaacs/nave/master/nave.sh > /bin/nave \
 && chmod a+x /bin/nave

RUN nave usemain stable

ADD . /src
RUN cd /src \
 && (rm -rf node_modules || exit 0) \
 && npm install

RUN cp -a /usr/bin/nodejs /usr/bin/node

RUN /usr/bin/mongod --smallfiles --fork --logpath mongo.log \
 && sleep 2 \
 && /src/bin/strider addUser --email test@example.com --password password --admin true

 # && /usr/bin/mongod --shutdown \
 # && /usr/bin/mongod --smallfiles --fork --logpath mongo.log \
 # && sleep 2 \
 # && echo "db.users.find()" | mongo localhost/strider-foss | grep test@example.com

WORKDIR /src
CMD ["docker/start-strider.sh"]

# 22 is ssh server
# 3000 is strider
# You can find out what ports they are mapped to on your host by running `docker ps`
EXPOSE 22 3000
