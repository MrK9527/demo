# Mavenのビルド用イメージ（Docker Hub）
FROM maven:3.8.8-eclipse-temurin-17 AS build

WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# 実行環境（Red Hat UBI）
FROM registry.redhat.io/ubi8/openjdk-17

WORKDIR /app
USER 185
COPY --from=build /app/target/*.jar app.jar
ENV JAVA_OPTS="-Xms512m -Xmx1024m"
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]

EXPOSE 8080