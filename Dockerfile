# https://pkgs.alpinelinux.org/packages
FROM alpine:latest

RUN apk add --no-cache bash

# add jq for creating json
RUN apk add jq

# add curl for creating releases via github api
RUN apk add curl

COPY error-matcher.json /error-matcher.json

COPY entrypoint.sh /entrypoint.sh

RUN chmod 777 entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]