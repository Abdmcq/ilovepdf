FROM ubuntu:22.04

# تثبيت Python 3.11
RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3-pip wget tree fontconfig libxrender1 libxext6 libjpeg-turbo8 libpng16-16 xfonts-base xfonts-75dpi ocrmypdf \
 && rm -rf /var/lib/apt/lists/*

# إعداد alias للبايثون
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.11 1

WORKDIR /ILovePDF

COPY ILovePDF/requirements.txt requirements.txt
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY ILovePDF/libgenesis/requirements.txt requirements.txt
RUN pip install -r requirements.txt

# تثبيت wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
 && apt-get install -y ./wkhtmltox_0.12.6.1-3.jammy_amd64.deb \
 && rm wkhtmltox_0.12.6.1-3.jammy_amd64.deb

COPY /ILovePDF .

RUN tree

CMD bash run.sh
