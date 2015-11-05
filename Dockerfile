FROM blacklabelops/java-jre-8
MAINTAINER Steffen Bleul <sbl@blacklabelops.com>

# Propert permissions
ENV CONTAINER_USER hsql
ENV CONTAINER_UID 1000
ENV CONTAINER_GROUP hsql
ENV CONTAINER_GID 1000

RUN /usr/sbin/groupadd --gid $CONTAINER_GID hsql && \
    /usr/sbin/useradd --uid $CONTAINER_UID --gid $CONTAINER_GID --create-home --shell /bin/bash hsql

# install dev tools
RUN yum install -y \
    wget && \
    yum clean all && rm -rf /var/cache/yum/*

# install git-lfs
ENV HSQLDB_VERSION=2.3.3
RUN mkdir -p /opt/database && \
    mkdir -p /opt/hsqldb && \
    mkdir -p /opt/sqltool && \
    wget -O /opt/hsqldb/hsqldb.jar http://central.maven.org/maven2/org/hsqldb/hsqldb/${HSQLDB_VERSION}/hsqldb-${HSQLDB_VERSION}.jar && \
    wget -O /opt/sqltool/sqltool.jar http://central.maven.org/maven2/org/hsqldb/sqltool/${HSQLDB_VERSION}/sqltool-${HSQLDB_VERSION}.jar && \
    chown -R $CONTAINER_UID:$CONTAINER_GID /opt/hsqldb /opt/database /opt/sqltool

VOLUME ["/opt/database"]
EXPOSE 9001

ENV JAVA_VM_PARAMETERS=

USER $CONTAINER_UID
WORKDIR /opt/database
COPY imagescripts/docker-entrypoint.sh /opt/hsqldb/docker-entrypoint.sh
ENTRYPOINT ["/opt/hsqldb/docker-entrypoint.sh"]
CMD ["hsqldb"]
