FROM python:3.11
RUN mkdir /pdf && chmod 777 /pdf

WORKDIR /ILovePDF

COPY ILovePDF/requirements.txt requirements.txt
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY ILovePDF/libgenesis/requirements.txt requirements.txt
RUN pip install -r requirements.txt

RUN apt update
RUN apt install -y ocrmypdf
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.jammy_amd64.deb && dpkg -i wkhtmltox_0.12.6.1-3.jammy_amd64.deb && apt-get install -y --fix-broken

COPY /ILovePDF .

RUN apt-get install -y tree
RUN tree

CMD bash run.sh
