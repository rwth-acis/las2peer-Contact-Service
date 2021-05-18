FROM openjdk:14-jdk-alpine

ENV LAS2PEER_PORT=9011

RUN apk add --update bash && rm -f /var/cache/apk/*

RUN addgroup -g 1000 -S las2peer && \
    adduser -u 1000 -S las2peer -G las2peer

USER las2peer
WORKDIR /src

# Get gradle distribution
COPY --chown=las2peer:las2peer *.gradle gradle.* gradlew /src/
COPY --chown=las2peer:las2peer gradle /src/gradle
RUN ./gradlew --version

# Add files
COPY --chown=las2peer:las2peer . /src

# Build
RUN ./gradlew --no-daemon build

EXPOSE $LAS2PEER_PORT

RUN chmod +x /src/docker-entrypoint.sh
ENTRYPOINT ["/src/docker-entrypoint.sh"]
