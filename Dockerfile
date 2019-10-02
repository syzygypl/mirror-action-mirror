FROM alpine

RUN apk add bash git grep sed openssh bind-tools

COPY scripts/*.sh /bin/

RUN chmod -R +x /bin

ENTRYPOINT '/bin/mirror.sh'
