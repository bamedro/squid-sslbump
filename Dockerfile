FROM centos:6

MAINTAINER jamesyale james.yale@specsavers.com

COPY ngtech-squid.repo /etc/yum.repos.d/ngtech-squid.repo

RUN yum update -y && yum install -y epel-release && yum clean -y all

RUN yum update -y && yum install -y squid squid-helpers && yum clean -y all

COPY squid-config/squid.ssl.conf /etc/squid/squid.ssl.conf

COPY squid-config/ssl.pem /etc/squid/ssl.pem

RUN yum update -y && yum install -y httpd-tools && yum clean -y all

RUN htpasswd -bc /etc/squid/squidusers brian P@ssw0rd

RUN chmod o+r /etc/squid/squidusers

RUN openssl req -new -newkey rsa:2048 \
       -batch \
       -sha256 -days 365 -nodes \
       -extensions v3_ca  -x509 \
       -keyout /etc/squid/ssl.pem \
       -out /etc/squid/ssl.pem

# create squid cache dirs
RUN /usr/sbin/squid -N -z -f /etc/squid/squid.ssl.conf

# create ssl_crtd working dir
RUN /usr/lib64/squid/ssl_crtd -c -s /var/spool/squid/ssl_db

RUN chmod a+r /var/spool/squid/ssl_db

RUN chmod a+r /etc/squid/*

RUN chown squid:squid /etc/squid /etc/squid/* /var/spool/squid/ /var/spool/squid/*

EXPOSE 3128

VOLUME ["/var/log"]

CMD ["/usr/sbin/squid", "-N", "-f", "/etc/squid/squid.ssl.conf"]
