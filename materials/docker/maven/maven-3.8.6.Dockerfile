FROM openjdk:8u212-jdk-alpine3.9 AS openjdk

COPY maven.tgz /

# https://wiki.alpinelinux.org/wiki/Setting_the_timezone
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add tzdata curl && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo Asia/Shanghai  > /etc/timezone && \
    mkdir -p /maven/ && tar -xvf /maven.tgz -C /maven/ --strip-components=1 && rm -rf /maven.tgz && \
    apk del tzdata curl

ENTRYPOINT [ "/maven/bin/mvn" ]