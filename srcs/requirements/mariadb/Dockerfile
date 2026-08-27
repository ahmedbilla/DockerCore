FROM debian:12

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY conf/config.cnf /etc/mysql/mariadb.conf.d/config.cnf

COPY tools/init.sh /tools/init.sh
RUN chmod +x /tools/init.sh

EXPOSE 3306

ENTRYPOINT ["/tools/init.sh"]