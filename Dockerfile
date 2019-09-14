FROM centos:7

RUN yum install git -y

COPY scripts/*.sh /bin/

RUN chmod -R +x /bin

ENTRYPOINT '/bin/mirror.sh'
