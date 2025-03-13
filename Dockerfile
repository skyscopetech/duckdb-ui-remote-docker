FROM haproxy:bookworm

USER root
# Install curl and OpenSSL
RUN apt-get update && apt-get install -y curl screen openssl

# Install the duckdb CLI
RUN curl https://install.duckdb.org | sh

# Create directory for SSL certificates
RUN mkdir -p /etc/ssl/private

# Generate self-signed certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/haproxy.key \
    -out /etc/ssl/private/haproxy.crt \
    -subj "/CN=localhost" \
    -addext "subjectAltName=DNS:localhost,IP:127.0.0.1" && \
    cat /etc/ssl/private/haproxy.crt /etc/ssl/private/haproxy.key > /etc/ssl/private/haproxy.pem && \
    chmod 600 /etc/ssl/private/haproxy.pem

# Copy custom configuration file from the current directory
COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY startup.sh ./startup.sh
RUN chmod +x ./startup.sh

# Expose ports
EXPOSE 8443

# Command to run the application
CMD ["bash", "startup.sh"]
