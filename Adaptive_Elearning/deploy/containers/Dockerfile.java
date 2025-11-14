# syntax=docker/dockerfile:1.7

ARG MAVEN_IMAGE=maven:3.9.8-eclipse-temurin-21
ARG TOMCAT_IMAGE=tomcat:10.1.30-jdk21-temurin

FROM ${MAVEN_IMAGE} AS build
WORKDIR /workspace

COPY pom.xml .
COPY mvn ./mvn
COPY lib ./lib
COPY src ./src

RUN mvn -B -DskipTests=true clean package

FROM ${TOMCAT_IMAGE} AS runtime
ENV APP_HOME=/opt/app \
    JAVA_OPTS="-Xms512m -Xmx1024m -XX:MaxMetaspaceSize=256m" \
    CATALINA_OPTS="-Djava.security.egd=file:/dev/./urandom" \
    TZ=UTC

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl tini gettext-base unzip && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/tomcat
RUN rm -rf webapps/*

COPY --from=build /workspace/target/Adaptive_Elearning.war /usr/local/tomcat/webapps/ROOT.war
RUN unzip webapps/ROOT.war -d webapps/ROOT && rm webapps/ROOT.war

COPY deploy/config/env.properties.tmpl ${APP_HOME}/env.properties.tmpl
COPY deploy/containers/java-entrypoint.sh /opt/app/entrypoint.sh
RUN chmod +x /opt/app/entrypoint.sh

HEALTHCHECK --interval=30s --timeout=5s --start-period=60s --retries=3 \
    CMD curl -fsS http://127.0.0.1:8080/healthz || curl -fsS http://127.0.0.1:8080/

EXPOSE 8080
ENTRYPOINT ["/usr/bin/tini","--","/opt/app/entrypoint.sh"]
CMD ["catalina.sh","run"]

