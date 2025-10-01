# استخدم Ubuntu 22.04 بدلاً من Debian
FROM ubuntu:22.04

# منع الـ prompt أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# تحديث النظام وتثبيت الحزم الأساسية
RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3-pip \
    wget tree git curl \
    fontconfig libxrender1 libxext6 libjpeg-turbo8 libpng16-16 \
    xfonts-base xfonts-75dpi ocrmypdf \
 && rm -rf /var/lib/apt/lists/*

# إعداد alias للبايثون
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

# تثبيت wkhtmltopdf (نسخة 0.12.6.1 متوافقة مع Ubuntu 22.04)
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
 && apt-get install -y ./wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
 && rm wkhtmltox_0.12.6.1-3.jammy_amd64.deb

# إنشاء مجلد البيانات
RUN mkdir /pdf && chmod 777 /pdf

# تعيين مسار العمل
WORKDIR /ILovePDF

# تثبيت المتطلبات الأساسية
COPY ILovePDF/requirements.txt requirements.txt
RUN pip install --upgrade pip && pip install -r requirements.txt

# تثبيت متطلبات libgenesis
COPY ILovePDF/libgenesis/requirements.txt requirements.txt
RUN pip install -r requirements.txt

# نسخ الكود
COPY /ILovePDF .

# فقط للفحص (ممكن تحذف tree لاحقاً)
RUN tree

# أمر التشغيل
CMD bash run.sh
