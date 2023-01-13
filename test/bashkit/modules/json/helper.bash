#!/usr/bin/env bash
# helper.bash --
# wuage bash script devkit test suite
# ----
# (ɔ) 2022 wuage.org

# shellcheck disable=SC2034  # vars are used in tests

# additionnally mock bashkit check::cmd
check::cmd() { :; }

# made with jq sorted and indent=4
json=\
'{
    "clients": {
        "data": [
            [
                "gamma",
                "delta"
            ],
            [
                1,
                2
            ]
        ],
        "hosts": [
            "alpha",
            "omega"
        ]
    },
    "database": {
        "connection_max": 5000,
        "enabled": true,
        "ports": [
            8001,
            8001,
            8002
        ],
        "server": "192.168.1.1"
    },
    "owner": {
        "dob": "1979-05-27 07:32:00-08:00",
        "name": "Tom Preston-Werner"
    },
    "servers": {
        "alpha": {
            "dc": "eqdc10",
            "ip": "10.0.0.1"
        },
        "beta": {
            "dc": "eqdc10",
            "ip": "10.0.0.2"
        }
    },
    "title": "Example"
}'

# raw dump
toml=\
'title = "Example"

[clients]
data = [ [ "gamma", "delta",], [ 1, 2,],]
hosts = [ "alpha", "omega",]

[database]
connection_max = 5000
enabled = true
ports = [ 8001, 8001, 8002,]
server = "192.168.1.1"

[owner]
dob = "1979-05-27 07:32:00-08:00"
name = "Tom Preston-Werner"

[servers.alpha]
dc = "eqdc10"
ip = "10.0.0.1"

[servers.beta]
dc = "eqdc10"
ip = "10.0.0.2"'

# raw dump
yaml=\
"clients:
  data:
  - - gamma
    - delta
  - - 1
    - 2
  hosts:
  - alpha
  - omega
database:
  connection_max: 5000
  enabled: true
  ports:
  - 8001
  - 8001
  - 8002
  server: 192.168.1.1
owner:
  dob: '1979-05-27 07:32:00-08:00'
  name: Tom Preston-Werner
servers:
  alpha:
    dc: eqdc10
    ip: 10.0.0.1
  beta:
    dc: eqdc10
    ip: 10.0.0.2
title: Example"
