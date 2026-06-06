# Production Zabbix HA Stack

Production-grade highly available monitoring infrastructure using PostgreSQL 16, Patroni, etcd, Keepalived, HAProxy and Zabbix 7.0.

---

# Overview

This project demonstrates a complete high availability architecture for Zabbix monitoring infrastructure with automatic PostgreSQL failover, frontend redundancy and distributed cluster management.

The environment was built and tested on Ubuntu 24.04 servers.

---

# Features

* PostgreSQL High Availability
* Patroni automatic failover
* etcd distributed consensus
* Keepalived Virtual IP failover
* Zabbix HA nodes
* HAProxy frontend load balancing
* Production-style architecture
* Multi-node redundancy
* No single point of failure

---

# Architecture

![Architecture Diagram](diagrams/architecture.svg)

---

# Topology

| Component             | Count |
| --------------------- | ----- |
| PostgreSQL Nodes      | 3     |
| Zabbix Nodes          | 2     |
| Virtual IP            | 1     |
| HAProxy Load Balancer | 1     |

---

# Technology Stack

| Technology    | Purpose                  |
| ------------- | ------------------------ |
| PostgreSQL 16 | Database                 |
| Patroni       | PostgreSQL HA management |
| etcd          | Distributed consensus    |
| Keepalived    | Virtual IP failover      |
| Zabbix 7.0    | Monitoring platform      |
| HAProxy       | Frontend load balancing  |
| Ubuntu 24.04  | Operating system         |

---

# Documentation

| Section                 | Description                         |
| ----------------------- | ----------------------------------- |
| PostgreSQL Installation | PostgreSQL setup and replication    |
| ETCD Installation       | Distributed consensus configuration |
| Patroni Configuration   | PostgreSQL cluster management       |
| Keepalived Setup        | VIP failover                        |
| Zabbix HA Setup         | Zabbix cluster configuration        |
| HAProxy Setup           | Frontend load balancing             |
| Failover Testing        | HA scenario validation              |
| Troubleshooting         | Common issues and fixes             |

---

# High Availability Workflow

1. Patroni manages PostgreSQL cluster leadership
2. etcd stores distributed cluster state
3. Keepalived moves the VIP between database nodes
4. Zabbix HA switches active server automatically
5. HAProxy distributes frontend traffic

---

# Tested Failover Scenarios

* PostgreSQL primary node failure
* Patroni leader re-election
* Keepalived VIP migration
* Zabbix HA failover
* Frontend redundancy validation

---

# Lessons Learned

* Proper PostgreSQL replication configuration is critical
* VIP migration timing impacts reconnect behavior
* Patroni and etcd provide reliable HA orchestration
* HA testing is essential before production deployment

---

# Future Improvements

* Docker deployment
* Kubernetes support
* Ansible automation
* Prometheus/Grafana integration
* TLS encryption between nodes

---

# Disclaimer

This project is intended for educational and production-lab environments. Review all security settings before using in production.

---

# Author

Soroush Mehmandoust
