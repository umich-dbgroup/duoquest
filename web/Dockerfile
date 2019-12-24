FROM tiangolo/meinheld-gunicorn:python3.7

COPY ./web /app
COPY ./duoquest /app/duoquest
COPY ./requirements.txt /app/requirements.txt
COPY ./docker_cfg.ini /app/docker_cfg.ini

VOLUME /home/data

RUN ["pip", "install", "-r", "requirements.txt"]
