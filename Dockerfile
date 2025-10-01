FROM python:3.11

# إنشاء مجلد لحفظ ملفات PDF
RUN mkdir /pdf && chmod 777 /pdf

# تعيين مجلد العمل
WORKDIR /ILovePDF

# تثبيت متطلبات Python
COPY ILovePDF/requirements.txt requirements.txt
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY ILovePDF/libgenesis/requirements.txt requirements.txt
RUN pip install -r requirements.txt

# تحديث النظام وتثبيت الأدوات المطلوبة
RUN apt update && apt install -y \
    ocrmypdf \
    fontconfig \
    libxrender1 \
    libxext6 \
    libjpeg62-turbo \
    libpng16-16 \
    xfonts-base \
    xfonts-75dpi \
    wget \
    tree \
 && rm -rf /var/lib/apt/lists/*

# تثبيت wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
 && apt-get install -y ./wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
 && rm wkhtmltox_0.12.6.1-3.jammy_amd64.deb

# نسخ المشروع
COPY /ILovePDF .

# استعراض الشجرة (للاختبار)
RUN tree

# تشغيل السكربت
CMD bash run.sh
