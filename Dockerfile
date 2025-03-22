# 使用するベースイメージを指定
# FROM openjdk:17-slim

# 作業ディレクトリを作成
# WORKDIR /app

# アプリケーションのソースコードをコンテナにコピー
# COPY . /app

# Mavenを使用してアプリケーションをビルド
# OpenJDK 17のイメージにはmavenがインストールされていないため、インストールを行う場合もあります
# RUN apt-get update && apt-get install -y maven

# Mavenビルドを実行（必要に応じてビルドコマンドを修正）
# RUN mvn clean install

# 実行するJARファイルを指定（ビルド後にJARが作成されると仮定）
# CMD ["java", "-jar", "target/my-app.jar"]



# 第 1 阶段: 使用 Maven 进行构建
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 第 2 阶段: 运行时仅使用 JRE (更小)
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=builder /app/target/myapp.jar .
CMD ["java", "-jar", "myapp.jar"]

# 删除 Maven 缓存
RUN mvn clean package -DskipTests && rm -rf /root/.m2

# 使用 jlink 创建最小化 JRE
FROM eclipse-temurin:17-jdk-alpine AS builder
RUN jlink --no-header-files --no-man-pages --strip-debug \
  --compress=2 --module-path /opt/java/openjdk/jmods \
  --add-modules java.base,java.logging \
  --output /custom-jre

FROM alpine:latest
COPY --from=builder /custom-jre /opt/java
ENV JAVA_HOME=/opt/java
CMD ["/opt/java/bin/java", "-jar", "myapp.jar"]

# 使用 distroless 进一步缩小
FROM gcr.io/distroless/java17-debian11
COPY target/myapp.jar /
CMD ["myapp.jar"]


# ポートを開放
EXPOSE 8080
