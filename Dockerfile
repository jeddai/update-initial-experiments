FROM ubuntu:latest

RUN apt-get update
RUN apt-get install curl jq git -y

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
