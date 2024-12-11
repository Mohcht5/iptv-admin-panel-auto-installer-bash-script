# استخدام صورة Ubuntu 20.04
FROM ubuntu:20.04

# تعيين البيئة الافتراضية لتجنب مطالبة المستخدمين أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# تحديث النظام وتثبيت الأدوات الأساسية
RUN apt-get update -y && \
    apt-get install -y software-properties-common wget curl sudo vim && \
    apt-get clean

# إضافة مستودع PHP إذا كنت بحاجة إلى إصدار PHP حديث
RUN add-apt-repository ppa:ondrej/php && \
    apt-get update -y

# تثبيت PHP والحزم الأساسية
RUN apt-get install -y php7.4 php7.4-cli php7.4-pgsql php7.4-curl php7.4-gd php-pear libjansson-dev libssh2-php libxslt1.1 apache2 && \
    apt-get clean

# تثبيت PostgreSQL
RUN apt-get update -y && \
    apt-get install -y postgresql postgresql-client && \
    apt-get clean

# إضافة أدوات أخرى مثل unzip و wget
RUN apt-get update -y && \
    apt-get install -y unzip && \
    apt-get clean

# إزالة الملفات المؤقتة
RUN rm -rf /var/lib/apt/lists/*

# نسخ ملف index.php إلى /var/www/html
COPY index.php /var/www/html/

# فتح المنفذ 80
EXPOSE 80

# بدء Apache
CMD ["apache2ctl", "-D", "FOREGROUND"]
