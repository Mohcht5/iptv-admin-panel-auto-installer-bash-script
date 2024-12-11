# استخدم Ubuntu كأساس للتثبيت
FROM ubuntu:20.04

# تثبيت المتطلبات الأساسية
RUN apt-get update && \
    apt-get install -y \
    apache2 \
    mysql-server \
    php \
    php-mysql \
    wget \
    curl \
    unzip \
    git \
    openssl \
    cron \
    tput \
    iputils-ping \
    && apt-get clean

# إعداد بيئة العمل
ENV LANG en_US.UTF-8

# نسخ سكربت التثبيت إلى الحاوية
COPY install-script.sh /install-script.sh

# إعطاء صلاحيات تنفيذ للسكريبت
RUN chmod +x /install-script.sh

# تغيير المسار الحالي إلى الدليل الذي يحتوي على السكربت
WORKDIR /

# تنفيذ السكربت
RUN ./install-script.sh

# فتح المنفذ 80 و 3306 للخوادم
EXPOSE 80 3306

# بدء Apache و MySQL و Cron
CMD service apache2 start && service mysql start && cron && tail -f /dev/null
