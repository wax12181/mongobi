FROM ryanhs/mongodb-bi-connector:debian-stretch

WORKDIR /workspace

COPY ./docker /workspace

ENV MONGODB_HOST 10.103.102.130
ENV MONGODB_PORT 27017
ENV MONGODB_USERNAME root
ENV MONGODB_PASSWORD ba5zPgsY9Icbi4qPj3LdTULYsnZsI76o
ENV MONGODB_DB esop-ticket
ENV LISTEN_PORT 3307

RUN dpkg -i /workspace/openssl/multiarch-support_2.28-10_amd64.deb \
&& dpkg -i /workspace/openssl/libssl1.0.0_1.0.2l-1~bpo8+1_amd64.deb \
&& dpkg -i /workspace/openssl/openssl_1.0.2l-1~bpo8+1_amd64.deb \
&& mkdir -p /opt/mongo-bi/crt/ && mkdir -p /opt/mongo-bi/logs/ && cd /opt/mongo-bi/crt/ \
&& openssl req -nodes -newkey rsa:2048 -keyout kayakwiseDE.key -out kayakwiseDE.crt -x509 -days 3650 -subj "/C=US/ST=kayakwiseDE/L=kayakwiseDE/O=kayakwiseDE Security/OU=IT Department/CN=kayakwise.com" \
&& cat /opt/mongo-bi/crt/kayakwiseDE.crt /opt/mongo-bi/crt/kayakwiseDE.key > /opt/mongo-bi/crt/kayakwiseDE.pem

EXPOSE 3307
CMD ["bash", "-c", "/workspace/bin/mongodrdl -h $MONGODB_HOST:$MONGODB_PORT -u $MONGODB_USERNAME -p $MONGODB_PASSWORD -d $MONGODB_DB --authenticationDatabase admin -o /opt/mongo-bi/schemas/schemas && /workspace/bin/mongosqld --logPath /opt/mongo-bi/logs/mongosqld.log --logAppend --mongo-uri mongodb://$MONGODB_HOST:$MONGODB_PORT/?connect=direct --addr 0.0.0.0:$LISTEN_PORT --sslMode allowSSL --sslPEMKeyFile /opt/mongo-bi/crt/kayakwiseDE.pem --sslAllowInvalidCertificates --auth -u $MONGODB_USERNAME -p $MONGODB_PASSWORD --schema /opt/mongo-bi/schemas --maxVarcharLength 65535"]