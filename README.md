# Production Zabbix HA Stack

Highly available monitoring infrastructure using:

* PostgreSQL 16
* Patroni
* etcd
* Keepalived
* HAProxy
* Zabbix 7.0
* Ubuntu 24.04

---

## Architecture Overview

This project demonstrates a production-style high availability architecture for Zabbix monitoring infrastructure.

Features:

* PostgreSQL automatic failover
* Patroni cluster management
* etcd distributed consensus
* VIP failover using Keepalived
* Zabbix HA nodes
* HAProxy frontend load balancing
* No single point of failure

---

## Topology

* 3 Database Nodes
* 2 Zabbix Application Nodes
* 1 Virtual IP
* HAProxy Load Balancer

---

## Components

| Component  | Purpose                 |
| ---------- | ----------------------- |
| PostgreSQL | Database                |
| Patroni    | PostgreSQL HA           |
| etcd       | Distributed consensus   |
| Keepalived | VIP failover            |
| Zabbix     | Monitoring platform     |
| HAProxy    | Frontend load balancing |

---

## Documentation

* PostgreSQL Installation
* ETCD Installation
* Patroni Configuration
* Keepalived Configuration
* Zabbix HA Setup
* HAProxy Configuration
* Failover Testing

---

## Project Status

Work in progress 🚀

