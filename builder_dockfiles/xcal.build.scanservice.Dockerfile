FROM python:3.7.9
ENV WORK_DIR="/ws/xcal/app"

RUN pip3 install requests flask docker prometheus-client kafka-python jaeger-client python-logstash psutil minio -i https://mirrors.aliyun.com/pypi/simple/ \
    && mkdir -p $WORK_DIR

WORKDIR $WORK_DIR
