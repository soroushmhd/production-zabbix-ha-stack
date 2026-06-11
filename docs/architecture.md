# Architecture Overview

This document describes the overall architecture of the Production Zabbix HA Stack.

---

# Architecture Goals

The environment was designed to provide:

* High availability for PostgreSQL
* Automatic failover and leader election
* Redundant Zabbix server nodes
* Frontend load balancing
* Elimination of single points of failure
* Production-style operational behavior

---

# Core Components

| Component     | Purpose                     |
| ------------- | --------------------------- |
| PostgreSQL 16 | Main database backend       |
| Patroni       | PostgreSQL HA orchestration |
| ETCD          | Distributed consensus store |
| Keepalived    | Virtual IP failover         |
| Zabbix 7.0    | Monitoring platform         |
| HAProxy       | Frontend load balancing     |

---

# PostgreSQL High Availability Design

The PostgreSQL cluster consists of 3 database nodes.

Patroni manages:

* Leader election
* Replica synchronization
* Automatic failover
* Cluster state management

ETCD is used as the distributed consensus backend for Patroni.

At any time:

* One node operates as Primary
* Remaining nodes operate as Replicas

---

# Virtual IP Workflow

Keepalived manages a floating Virtual IP (VIP).

The VIP always points to the active PostgreSQL primary node.

This allows:

* Stable database connectivity
* Transparent failover
* Minimal application downtime

Applications connect only to the VIP instead of individual database nodes.

---

# Zabbix High Availability

Two Zabbix server nodes are deployed.

Zabbix native HA mode provides:

* Active node selection
* Standby failover
* Shared database backend support

Both Zabbix nodes connect to the PostgreSQL VIP.

---

# Frontend Load Balancing

HAProxy distributes frontend traffic between Zabbix frontend nodes.

Features include:

* Backend health checks
* Automatic failed node removal
* Traffic distribution
* Improved frontend availability

---

# Network Flow

```text
Users
   ↓
HAProxy
   ↓
Zabbix Frontend Nodes
   ↓
PostgreSQL VIP
   ↓
Patroni Cluster
   ↓
ETCD Consensus Layer
```

---

# Failover Workflow

## PostgreSQL Failure

1. Primary node becomes unavailable
2. Patroni detects failure
3. ETCD confirms cluster state
4. New primary is elected
5. Keepalived migrates VIP
6. Applications reconnect automatically

---

# Zabbix HA Failover

1. Active Zabbix node fails
2. Standby node becomes active
3. Frontend traffic continues through HAProxy

---

# Architecture Diagram

The repository includes a visual architecture diagram:

```text
diagrams/architecture.svg
```

---

# Production Considerations

This project demonstrates a production-style HA architecture.

Real production deployments should additionally consider:

* TLS encryption
* Backup strategies
* Monitoring and alerting
* Firewall segmentation
* Multi-site replication
* Disaster recovery procedures
* HAProxy redundancy
* ETCD quorum protection
