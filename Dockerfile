FROM debian:12.9

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl iputils-ping && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
