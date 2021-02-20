FROM maven:3.6.3-jdk-11

WORKDIR /
COPY ./start-server.sh /
RUN chmod +x ./start-server.sh
COPY karate.jar /
RUN mkdir /karate
EXPOSE 9000
CMD ["./start-server.sh"]