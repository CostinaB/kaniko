FROM ubuntu:latest
COPY entrypoint.sh /entrypoint.sh
RUN ls -al && chmod 777 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
