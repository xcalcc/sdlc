FROM hub.xcalibyte.co/sdlc/xcal.build.mainservice:1.0 AS builder

COPY .m2 /root/.m2

COPY workdir/ $WORK_DIR

#ENV M2_HOME=/root/.m2

RUN mvn clean package -Dmaven.test.skip=true

FROM openjdk:11

RUN mkdir -p /ws/xcal/app

COPY --from=builder /home/sdlc/target/web-api-service-main.jar /ws/xcal/app
COPY ./VER /VER

WORKDIR /ws/xcal/app

ENTRYPOINT java ${JAVA_OPTS} -jar web-api-service-main.jar

