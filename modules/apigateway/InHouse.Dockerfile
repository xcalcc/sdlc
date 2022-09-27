FROM nginx:1.16.1

COPY workdir/xcal.nginx/apigateway /ws/xcal/app/nginx
COPY workdir/xcal.nginx/apigateway/xcal.nginx.conf /etc/nginx/nginx.conf
COPY ./VER /VER

WORKDIR /ws/xcal/app

CMD bash -c "nginx '-g' 'daemon off;'"
