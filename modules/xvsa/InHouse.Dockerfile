FROM ubuntu:16.04

RUN apt-get update  \
    && apt-get install -y git bison flex build-essential gcc-multilib libc6-dev \
    libc6-dev-i386 openjdk-8-jdk cmake make gradle python3 python curl gcc-4.9 g++-4.9 && \
    apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV WORK_DIR="/ws/xcal/app"

RUN mkdir -p $WORK_DIR

ENV PATH=$PATH:${WORK_DIR}/bin

WORKDIR /ws/xcal/app


