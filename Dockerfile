FROM python:3.7-buster

COPY . /home/duoquest

VOLUME /home/data

WORKDIR /home/duoquest
RUN ["pip", "install", "-r", "requirements.txt"]
RUN ["python", "nltk_download.py"]

RUN ["mkdir", "-p", "/home/data/results"]

ENTRYPOINT ["python", "main.py"]
