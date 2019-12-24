FROM ubuntu:18.04

COPY ./spider /home/data/spider
COPY ./mas_smallest.sqlite /home/data/mas_smallest.sqlite

RUN ["mkdir", "-p", "/home/data/results"]

# Uncomment this if dataset available!
# COPY ./spider_test /home/data/spider_test

VOLUME /home/data
