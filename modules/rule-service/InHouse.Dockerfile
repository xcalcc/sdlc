FROM ubuntu:18.04

RUN apt update && apt -y install curl 

RUN mkdir -p /ws/xcal/app
COPY ./lib/rule-service /ws/xcal/app
COPY ./lib/VER /ws/xcal/app
COPY ./lib/VER /VER

WORKDIR /ws/xcal/app

EXPOSE 3003
CMD [ "./rule-service" ]