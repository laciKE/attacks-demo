FROM alpine:3.5 as build

RUN apk update && \
    apk add \
      openjdk8 \
      maven \
      git
RUN cd /root && \
    git clone https://github.com/mbechler/marshalsec.git && \
    cd marshalsec && \
    mvn clean package -DskipTests 

COPY POC.java /root

RUN cd /root && \
    /usr/lib/jvm/default-jvm/bin/javac POC.java

 
FROM alpine:3.5 as main

RUN echo "Minecraft Log4shell Container" && \
    apk update && \
    apk add \
      tmux \
      wget \
      openjdk8-jre-base \
      python3 && \
    adduser -D miner

COPY entrypoint.sh /home/miner/
COPY POC.java /home/miner/

COPY --from=build /root/POC.class /home/miner/
COPY --from=build /root/marshalsec/target/marshalsec-0.0.3-SNAPSHOT-all.jar /home/miner/marshalsec.jar

RUN chown -R miner:miner /home/miner

USER miner

RUN cd /home/miner && \
    chmod a+x entrypoint.sh && \
    mkdir server && \
    cd server && \
    wget --no-check-certificate --quiet https://launcher.mojang.com/v1/objects/5fafba3f58c40dc51b5c3ca72a98f62dfdae1db7/server.jar && \
    echo "39aef720dc5309476f56f2e96a516f3dd3041bbbf442cbfd47d63acbd06af31e  server.jar" > server_jar_sha256.txt && \
    sha256sum -c server_jar_sha256.txt && \
    echo "eula=true" > eula.txt && \
    echo online-mode=false > server.properties && \
    touch banned-ips.json banned-players.json ops.json whitelist.json && \
    cd && \
    mkdir poc && \
    cd poc && \
    mv ../*.class ./ && \
    mv ../*.java ./

EXPOSE 1389 8000 25565
CMD ["/home/miner/entrypoint.sh"]
