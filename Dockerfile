# استخدم صورة Ubuntu 20.04 كأساس
FROM ubuntu:20.04

# تحديث الحزم أولاً للتأكد من الحصول على أحدث النسخ
RUN apt-get update && apt-get upgrade -y

# تثبيت الحزم المطلوبة
RUN apt-get install -y \
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
    iputils-ping

# تنظيف الحزم غير الضرورية لتحسين حجم الصورة
RUN apt-get clean

# نسخ السكربت إلى الحاوية
COPY install-script.sh /install-script.sh

# إعطاء صلاحيات تنفيذ للسكريبت
RUN chmod +x /install-script.sh

# تنفيذ السكربت
RUN /install-script.sh

# فتح البورتات اللازمة
EXPOSE 80 443

# تعيين أمر بدء الحاوية (اختياري)
CMD ["apache2ctl", "-D", "FOREGROUND"]
