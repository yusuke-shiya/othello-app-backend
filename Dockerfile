# DockerHubから軽量のalpineイメージを選択する
FROM ruby:2.7.5-alpine

# docker-compose.ymlからWORKDIRの値を受け取る
ARG WORKDIR

# パッケージを永続使用/一時的使用の2つの変数にまとめる
ARG RUNTIME_PACKAGES="bash imagemagick nodejs yarn tzdata mysql-dev mysql-client git less"
ARG DEV_PACKAGES="build-base curl-dev"

# docker-composeで受け取ったWORKDIRを展開して、RailsコンテナのHOMEという環境変数を設定する(ホームディレクトリを設定)
ENV HOME=/${WORKDIR}

# HOMEを展開して、WORKDIRを設定する(作業ディレクトリをホームディレクトリと統一する)
WORKDIR ${HOME}

# ホストにあるGemfileとGemfile.lockをコンテナにコピーする
COPY Gemfile* ./

# パッケージのインストール　&　削除
RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies

# ホストのファイル一式をコンテナにコピーする
COPY . ./

# CMD実行前にentrypoint.shを通す
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# 開発用サーバーの実行
CMD ["rails", "server", "-b", "0.0.0.0"]
