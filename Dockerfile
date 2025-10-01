# نبدأ من صورة أساسية حديثة
FROM ubuntu:22.04

# منع أسئلة apt
ENV DEBIAN_FRONTEND=noninteractive

# تحديث النظام وتثبيت المتطلبات الأساسية
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    build-essential \
    wget \
    curl \
    git \
    xz-utils \
    gnupg \
    libssl-dev \
    libffi-dev \
    libjpeg-turbo8 \
    libpng-dev \
    libxrender1 \
    libx11-dev \
    libxext6 \
    libfontconfig1 \
    libfreetype6 \
    libxcb1 \
 && rm -rf /var/lib/apt/lists/*

# جعل python يشير إلى python3.11
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

# تثبيت wkhtmltopdf (نسخة رسمية متوافقة مع Jammy)
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
 && apt-get update && apt-get install -y ./wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
 && rm wkhtmltox_0.12.6.1-3.jammy_amd64.deb

# تحديد مجلد العمل
WORKDIR /ILovePDF

# نسخ متطلبات المشروع
COPY ILovePDF/requirements.txt requirements.txt

# حل مشكلة pdfminer.six المكسورة + تثبيت المتطلبات
RUN pip uninstall -y pdfminer.six || true \
 && pip install --upgrade pip \
 && pip install -r requirements.txt

# تثبيت متطلبات libgenesis
COPY ILovePDF/libgenesis/requirements.txt requirements.txt
RUN pip install -r requirements.txt

# نسخ باقي ملفات المشروع
COPY . .

# أمر التشغيل (غيره حسب مشروعك)
CMD ["python", "main.py"]
