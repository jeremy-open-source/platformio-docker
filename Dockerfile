FROM ubuntu:21.10

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
    && pip3 install platformio
