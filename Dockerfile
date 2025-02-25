# Mavenのベースイメージを指定
FROM maven:3.8.6-openjdk-17-slim AS build

# 作業ディレクトリを指定
WORKDIR /app

# プロジェクトのpom.xmlをコピー
COPY pom.xml .

# 依存関係をダウンロード
RUN mvn dependency:go-offline

# ソースコードをコピー
COPY src ./src

# アプリケーションのビルド
RUN mvn clean package -DskipTests

# 本番環境用の最小限のOpenJDK 17イメージを使用
FROM openjdk:17-slim

# 作業ディレクトリを指定
WORKDIR /app

# ビルドしたJARファイルをコピー
COPY --from=build /app/target/*.jar app.jar

# アプリケーションを実行
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# 必要に応じてポートを公開
EXPOSE 8080