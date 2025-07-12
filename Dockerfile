FROM ubuntu:24.04

RUN apt update && apt install -y rclone curl jq ccrypt

#COPY sa.json /root/sa.json
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

#CMD ./entrypoint.sh
