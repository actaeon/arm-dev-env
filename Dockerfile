FROM        ubuntu:18.04

MAINTAINER  bgreen@newrelic.com

RUN         apt-get update && \
            apt-get install -y binutils-arm-none-eabi \
            qemu-user \
            gcc-arm-linux-gnueabi \
            vim \
            gdb-multiarch \
            wget

RUN         cd /tmp && \ 
            wget https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz && \
            tar -C /usr/local -xzf go1.11.2.linux-amd64.tar.gz && \
            rm -f /tmp/go1.11.2.linux-amd64.tar.gz && \
            mkdir /usr/local/src/arm


ENV         GOPATH=/ \
            GOROOT=/usr/local/go \
            PATH=$PATH:/usr/local/go/bin

WORKDIR     /usr/local/src/arm


ENTRYPOINT  [ "/bin/bash" ]

