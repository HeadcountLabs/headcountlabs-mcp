#!/bin/sh
# Calls the no-account endpoint: initialize, list the tools, then count remote data engineer jobs in the US.
URL=https://api.headcountlabs.com/mcp/public
H1="content-type: application/json"
H2="accept: application/json, text/event-stream"
curl -s "$URL" -H "$H1" -H "$H2" -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"example","version":"1"}}}'
echo
curl -s "$URL" -H "$H1" -H "$H2" -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
echo
curl -s "$URL" -H "$H1" -H "$H2" -d '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"count_jobs","arguments":{"filters":{"title":"data engineer","country":"US","work_arrangement":"remote"}}}}'
echo
