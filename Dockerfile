# ビルドステージ（Mavenでアプリケーションをビルド）
FROM maven:3.8.6-openjdk-17-slim AS build

# 作業ディレクトリを設定
WORKDIR /app

# プロジェクトのpom.xmlをコピーし、依存関係をダウンロード
COPY pom.xml .
RUN mvn dependency:go-offline

# ソースコードをコピーしてビルド
COPY src ./src
RUN mvn clean package -DskipTests

# 実行ステージ（軽量なOpenJDK 17イメージを使用）
FROM registry.access.redhat.com/ubi8/openjdk-17-runtime

# OpenShiftのために非rootユーザーを使用
USER 185

# 作業ディレクトリの設定
WORKDIR /app

# ビルド成果物（JARファイル）をコピー
COPY --from=build /app/target/*.jar app.jar

# 環境変数を利用するように設定
ENV JAVA_OPTS="-Xms512m -Xmx1024m"

# アプリケーションを実行
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]

# OpenShiftでのヘルスチェック用ポートを指定
EXPOSE 8080