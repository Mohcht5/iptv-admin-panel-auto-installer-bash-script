# استخدم صورة Ubuntu رسمية كأساس
FROM ubuntu:20.04

# تعيين متغيرات البيئة
ENV DEBIAN_FRONTEND=noninteractive

# تحديث النظام وتثبيت الحزم الأساسية
RUN apt-get update -y && \
    apt-get install -y wget curl sudo vim && \
    apt-get clean

# تثبيت PostgreSQL
RUN apt-get update -y && \
    apt-get install -y postgresql postgresql-client && \
    apt-get clean

# تثبيت PHP والحزم ذات الصلة، مع تجنب استخدام php5-fpm لأنه قد يكون غير متوفر
RUN apt-get update -y && \
    apt-get install -y php php-cli php-pgsql php-curl php-gd php-pear libjansson-dev libssh2-php libxslt1.1 apache2 && \
    apt-get clean

# تثبيت الحزم الإضافية
RUN apt-get update -y && \
    apt-get install -y unzip python3 python3-pip daemontools && \
    apt-get clean

# إعداد قاعدة بيانات PostgreSQL
RUN pg_createcluster 9.3 main --start && \
    /etc/init.d/postgresql start && \
    sleep 3

# فتح المنافذ المطلوبة
EXPOSE 80 443

# بدء الخدمات عند بدء تشغيل الحاوية
CMD service apache2 start && \
    /opt/fulliptv/bin/start.sh
