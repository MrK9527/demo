# 使用するベースイメージを指定
FROM openjdk:17-slim

# 作業ディレクトリを作成
WORKDIR /app

# アプリケーションのソースコードをコンテナにコピー
COPY . /app

# Mavenを使用してアプリケーションをビルド
# OpenJDK 17のイメージにはmavenがインストールされていないため、インストールを行う場合もあります
RUN apt-get update && apt-get install -y maven

# Mavenビルドを実行（必要に応じてビルドコマンドを修正）
RUN mvn clean install

# 実行するJARファイルを指定（ビルド後にJARが作成されると仮定）
CMD ["java", "-jar", "target/my-app.jar"]

# ポートを開放
EXPOSE 8080
