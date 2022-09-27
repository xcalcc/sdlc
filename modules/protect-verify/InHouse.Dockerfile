FROM hub.xcalibyte.co/sdlc/xcal.build.pro-verify:1.0 AS builder

COPY workdir/ $WORK_DIR

RUN cd complete && ./mvnw clean package -Dmaven.test.skip=true

FROM openjdk:11

RUN mkdir -p /pro

COPY --from=builder /home/sdlc/complete/target/verify-service-0.1.0.jar /pro
COPY ./VER /VER

WORKDIR /pro

CMD ["java","-jar","verify-service-0.1.0.jar"]

