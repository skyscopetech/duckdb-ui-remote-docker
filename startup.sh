#!/bin/bash

# Run DuckDB UI in screen
screen -L -Logfile ./duckdb_ui.log -dmS duckdb_ui /var/lib/haproxy/.duckdb/cli/latest/duckdb -ui

# Run HAProxy
screen -L -Logfile ./haproxy.log -dmS haproxy_app haproxy -f /usr/local/etc/haproxy/haproxy.cfg

# Tail both logs
sleep 5
tail -f ./duckdb_ui.log ./haproxy.log
