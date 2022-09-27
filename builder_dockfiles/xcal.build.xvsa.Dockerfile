FROM centos:7

ENV WORK_DIR="/home/sdlc"

RUN yum -y install java-1.8.0-openjdk git maven which wget unzip bison flex make gcc \
    gcc-c++ glibc-devel glibc-devel.i686 glibc-static expect python36 sudo libstdc++-devel  \
    libstdc++-static && \
    yum clean all

# Gradle install
RUN wget https://downloads.gradle.org/distributions/gradle-4.5.1-all.zip && \
    unzip gradle-4.5.1-all.zip

# Cmake
RUN wget https://github.com/Kitware/CMake/releases/download/v3.16.5/cmake-3.16.5-Linux-x86_64.tar.gz && \
    tar xf cmake-3.16.5-Linux-x86_64.tar.gz

# Clang lib
RUN mkdir clang-prebuilt && cd clang-prebuilt && wget http://127.0.0.1:8888/clang-prebuilt/7.0.1/release-gcc4.tar.gz && \
    tar xf release-gcc4.tar.gz
#RUN mkdir clang-prebuilt && cd clang-prebuilt && wget http://127.0.0.1/clang_prebuilt/release.tar.gz && \
#    tar xf release.tar.gz

ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk"
ENV CLANG_HOME="/clang-prebuilt/release"
ENV PATH=$PATH:/gradle-4.5.1/bin:/cmake-3.16.5-Linux-x86_64/bin

WORKDIR $WORK_DIR
