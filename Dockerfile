FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN     apt-get update \
    &&  apt-get install -y \
            nano \
            apt-transport-https \
            apt-utils \
            ca-certificates \
            curl \
            make \
            python3 \
            python3-venv \
            python3-pip \
            openssh-client \
            git \
    && pip3 install platformio~=6.1.3

COPY bin/* /usr/local/bin/
