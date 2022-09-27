FROM hub.xcalibyte.co/sdlc/xcal.build.webpage:1.1 AS builder

RUN apt update && apt install make

COPY workdir/ $WORK_DIR

RUN npm config set registry https://registry.npmmirror.com && \
    yarn && yarn build

FROM nginx:1.16.1

COPY --from=builder /home/sdlc/cicd/inhouse-nginx-conf /ws/xcal/app/nginx
COPY --from=builder /home/sdlc/cicd/inhouse-nginx-conf/xcal.nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /home/sdlc/build /ws/xcal/app/nexus/build
COPY ./VER /VER

WORKDIR /ws/xcal/app

CMD bash -c 'sleep 10s' && nginx '-g' 'daemon off;'
