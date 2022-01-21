FROM rust:buster

RUN apt-get update -y
RUN apt-get install -y cmake erlang

WORKDIR /app

COPY . .

RUN make