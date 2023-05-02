# Extremely quick and simple dockerfile to get a basic service up
FROM python:3.11.3-alpine3.16

RUN apk add curl && \
    curl -o /etc/papertrail-bundle.pem https://papertrailapp.com/tools/papertrail-bundle.pem

WORKDIR /

RUN apk add --update -t build-dependencies wget ca-certificates \
  && wget -q -O - https://github.com/papertrail/remote_syslog2/releases/download/v0.21/remote_syslog_linux_amd64.tar.gz \
  | tar -zxf - \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/*

ADD entrypoint.sh /entrypoint.sh

WORKDIR /www

COPY ./simplewebsite ./

# Run the container with `docker run -p 8000:8000 <imagename>`
EXPOSE 80

# -u so that it doesn't buffer the logs
# 80 serves on port 80 to be more compatible with ECS which expects 80 by default
# CMD ["python3", "-u", "-m", "http.server", "80"]
CMD ["/entrypoint.sh"]