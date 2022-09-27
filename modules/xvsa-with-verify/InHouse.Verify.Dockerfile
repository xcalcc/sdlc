FROM openjdk:11

RUN mkdir -p /pro

COPY workdir/protect-verify/complete/target/verify-service-0.1.0.jar /pro
COPY workdir/protect-verify/VER /VER
COPY workdir/xvsa/ca.pub.signed /pro
COPY workdir/xvsa/middle.v1 /pro
COPY workdir/xvsa/test.ca.priv.pkcs8.pem /pro

WORKDIR /pro

CMD ["java","-jar","verify-service-0.1.0.jar"]

