FROM gradle:jdk11 AS builder

COPY workdir/ $WORK_DIR

RUN cd complete && ./mvnw clean package -Dmaven.test.skip=true

FROM openjdk:11

RUN mkdir -p /pro

COPY --from=builder /home/gradle/complete/target/relay-service-0.1.0.jar /pro
COPY ./VER /VER

WORKDIR /pro

CMD ["java","-jar","relay-service-0.1.0.jar"]