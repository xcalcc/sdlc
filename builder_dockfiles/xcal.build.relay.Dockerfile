FROM openjdk:11

ENV WORK_DIR="/home/sdlc"

RUN apt update  \
    && apt install -y maven \
    && apt -y autoremove \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $WORK_DIR

WORKDIR $WORK_DIR
