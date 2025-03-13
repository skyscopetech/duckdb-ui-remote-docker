FROM haproxy:bookworm

USER root
# Install curl, OpenSSL, and screen
RUN apt-get update && apt-get install -y curl screen openssl

USER haproxy
# Install the duckdb CLI
RUN curl https://install.duckdb.org | sh

# Generate self-signed certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout haproxy.key \
    -out haproxy.crt \
    -subj "/CN=localhost" \
    -addext "subjectAltName=DNS:localhost,IP:127.0.0.1" && \
    cat haproxy.crt haproxy.key > haproxy.pem && \
    chmod 644 haproxy.pem

# Copy custom configuration file from the current directory
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY startup.sh ./startup.sh

# Make the startup script executable
USER root
RUN chmod +x ./startup.sh
USER haproxy

# Expose ports
EXPOSE 8443

# Command to run the application
CMD ["bash", "startup.sh"]
