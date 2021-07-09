FROM ghcr.io/alexttyip/flutter-docker/flutter as flutter_build

COPY --chown=user . .

ARG COMMIT_SHA
ARG COMMIT_TIMESTAMP

RUN flutter build web --dart-define COMMIT_SHA="$COMMIT_SHA" --dart-define COMMIT_TIMESTAMP="$COMMIT_TIMESTAMP"

FROM nginx:alpine

WORKDIR /usr/share/nginx/html

COPY --from=flutter_build /home/user/build/web/ .
