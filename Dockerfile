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



# 第1阶段: 使用 Maven 构建
FROM maven:3.9.6-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# 第2阶段: 运行 JAR，使用更小的 JRE
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=builder /app/target/myapp.jar .
CMD ["java", "-jar", "myapp.jar"]


# ポートを開放
EXPOSE 8080
