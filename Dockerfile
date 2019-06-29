# FROM arm64v8/node:8.16.0-alpine
FROM arm64v8/node:10.16.0-alpine

# Experimental ARMv8 support for Node-RED

# add support for gpio library
# RUN apt-get update
# RUN apt-get install python-rpi.gpio

RUN \
    apk add --no-cache --virtual .build-dependencies \
        g++=8.3.0-r0 \
        gcc=8.3.0-r0 \
        libc-dev=0.7.1-r0 \
        linux-headers=4.18.13-r1 \
        make=4.2.1-r2 \
        py2-pip=18.1-r0 \
        python2-dev=2.7.16-r1 \
        bash

# Home directory for Node-RED application source code.
RUN mkdir -p /usr/src/node-red

# User data directory, contains flows, config and nodes.
RUN mkdir /data

WORKDIR /usr/src/node-red

# Add node-red user so we aren't running as root.
RUN adduser --home /usr/src/node-red -D -H node-red \
    && chown -R node-red:node-red /data \
    && chown -R node-red:node-red /usr/src/node-red

USER node-red

# package.json contains Node-RED NPM module and node dependencies
COPY package.json /usr/src/node-red/
RUN npm install

# User configuration directory volume
# EXPOSE 1880

# Environment variable holding file path for flows configuration
ENV FLOWS=flows.json

CMD ["npm", "start", "--", "--userDir", "/data"]
