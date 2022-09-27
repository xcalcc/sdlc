FROM ubuntu:18.04

RUN cp /etc/apt/sources.list /etc/apt/sources.list.bk && rm /etc/apt/sources.list && touch /etc/apt/sources.list && \
        echo deb "http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb "http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb "http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb "http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb "http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb-src "http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb-src "http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb-src "http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb-src "http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
        echo deb-src "http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
        apt-get update && apt-get upgrade --yes

#RUN apt-get update  \
#    && apt-get install -y git bison flex build-essential gcc-multilib libc6-dev \
#    libc6-dev-i386 openjdk-8-jdk cmake make gradle python3 python curl gcc-4.9 g++-4.9 && \
#    apt-get autoclean && \
#    apt-get clean && \
#    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install -y apt-utils git bison flex build-essential gcc-5 g++-5 gcc-5-multilib g++-5-multilib libc6-dev libc6-dev-i386 openjdk-8-jdk cmake make curl
RUN apt-get autoclean && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV WORK_DIR="/ws/xcal/app/xvsa"
ENV WORK_DIR_XSCA="/ws/xcal/app/xsca"

RUN mkdir -p $WORK_DIR && mkdir -p $WORK_DIR_XSCA

COPY workdir/xvsa/xvsa $WORK_DIR
COPY workdir/xvsa/COMPONENTS.json /VER

COPY workdir/mastiff-package-protect/package/start.sh $WORK_DIR/bin
COPY workdir/mastiff-package-protect/package/vtxtreader $WORK_DIR/bin
COPY workdir/mastiff-package-protect/package/xvsa_scan.sh $WORK_DIR/bin/xvsa_scan

COPY workdir/xsca/lib/xsca $WORK_DIR_XSCA
COPY workdir/mastiff-package-protect/package/xml2vtxt $WORK_DIR_XSCA
COPY workdir/xsca/lib/VER $WORK_DIR_XSCA
COPY workdir/xsca/lib/conf/* $WORK_DIR_XSCA/conf/

ENV PATH=$PATH:${WORK_DIR_XSCA}
ENV PATH=$PATH:${WORK_DIR}/bin
ENV XSCA_HOME=${WORK_DIR_XSCA}

WORKDIR /ws/xcal/app