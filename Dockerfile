# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV CMSVER='2.0'
ENV LANG="en_US.UTF-8"

# Install essential dependencies
RUN apt-get update -y && \
    apt-get install -y \
    postgresql \
    unzip \
    wget \
    curl \
    vim \
    sudo \
    python3 \
    python3-pip \
    php \
    php-cli \
    php-pgsql \
    php-curl \
    php-gd \
    php-pear \
    php5-fpm \
    libjansson-dev \
    libssh2-php \
    libxslt1.1 \
    daemontools \
    apache2 \
    postgresql-client \
    && apt-get clean

# Install FullIPTV dependencies
RUN wget https://bitbucket.org/karim2009/fulliptv-v4/downloads/ioncube.zip && \
    unzip ioncube.zip -d /opt && \
    chmod 777 /opt/fulliptv && \
    chmod 777 /opt/fulliptv/lib && \
    chmod 777 /opt/fulliptv/lib/ioncube && \
    rm ioncube.zip

# Set up PostgreSQL database
RUN pg_createcluster 9.3 main --start && \
    /etc/init.d/postgresql start && \
    sleep 3

# Install additional system tweaks and libraries
RUN echo "nameserver 8.8.8.8" > /etc/resolv.conf && \
    dpkg --remove-architecture i386 >> /dev/null 2>&1 && \
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf && \
    echo "fs.file-max = 32768" >> /etc/sysctl.conf && \
    sysctl -p >> /dev/null 2>&1

# Add FullIPTV configuration files
RUN mkdir -p /opt/fulliptv/etc/ && \
    echo "CMSURL=$CMSURL" > /opt/fulliptv/etc/fulliptv.conf && \
    echo "CMSPORT=$CMSPORT" >> /opt/fulliptv/etc/fulliptv.conf && \
    echo "SERVERNAME=$SERVERNAME" >> /opt/fulliptv/etc/fulliptv.conf && \
    echo "SERVERIP=$SERVERIP" >> /opt/fulliptv/etc/fulliptv.conf && \
    echo "SERVERINTIP=$SERVERINTIP" >> /opt/fulliptv/etc/fulliptv.conf && \
    echo "ISCMS=$ISCMS" >> /opt/fulliptv/etc/fulliptv.conf && \
    echo "ISSTREAMER=$ISSTREAMER" >> /opt/fulliptv/etc/fulliptv.conf

# Expose necessary ports
EXPOSE 80 443

# Start services on container start
CMD service apache2 start && \
    /opt/fulliptv/bin/start.sh
