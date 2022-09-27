FROM node:13

ENV WORK_DIR="/home/sdlc"

RUN apt update  \
    && apt install -y curl nodejs \
    && npm install chromedriver --chromedriver_cdnurl=https://npm.taobao.org/mirrors/chromedriver \
    && apt -y autoremove \
    && apt autoclean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p $WORK_DIR

WORKDIR $WORK_DIR
