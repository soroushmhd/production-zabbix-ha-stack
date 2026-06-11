# Prerequisites

This section describes the required environment before deployment.

---

# Infrastructure Requirements

| Component        | Requirement                     |
| ---------------- | ------------------------------- |
| Operating System | Ubuntu 24.04                    |
| PostgreSQL Nodes | 3                               |
| Zabbix Nodes     | 2                               |
| HAProxy Node     | 1                               |
| CPU              | Minimum 2 vCPU per node         |
| Memory           | Minimum 4GB RAM per node        |
| Network          | Full connectivity between nodes |

---

# Required Packages

* PostgreSQL 16
* Patroni
* etcd
* Keepalived
* HAProxy
* Zabbix 7.0

---

# Network Requirements

The following ports must be accessible:

| Service          | Port  |
| ---------------- | ----- |
| PostgreSQL       | 5432  |
| Patroni REST API | 8008  |
| ETCD             | 2379  |
| Zabbix Server    | 10051 |
| Zabbix Agent     | 10050 |
| HTTP             | 80    |

---

# Time Synchronization

All nodes should use synchronized time sources.

Recommended:

- chrony
- systemd-timesyncd

Time drift can impact:
- ETCD quorum stability
- Patroni leader election
- Failover timing

---
# Security Recommendations

* Restrict database access using firewall rules
* Use SCRAM-SHA-256 authentication
* Avoid exposing PostgreSQL publicly
* Use strong passwords for replication users
