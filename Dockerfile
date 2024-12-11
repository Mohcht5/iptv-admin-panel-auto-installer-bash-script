# استخدم صورة Ubuntu كأساس
FROM ubuntu:20.04

# تعيين بعض المتغيرات البيئية
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Africa/Casablanca

# تحديث الحزم أولاً
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
    iputils-ping \
    tzdata

# تكوين المنطقة الزمنية بشكل غير تفاعلي
RUN ln -fs /usr/share/zoneinfo/Africa/Casablanca /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

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
