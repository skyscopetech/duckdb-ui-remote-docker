#!/bin/bash

# Run DuckDB UI in screen
screen -dmS duckdb_ui /var/lib/haproxy/.duckdb/cli/latest/duckdb -ui

# Run HAProxy
haproxy -f /usr/local/etc/haproxy/haproxy.cfg
