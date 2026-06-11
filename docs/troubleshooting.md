# Troubleshooting Guide

This document contains common deployment and operational issues encountered during implementation of the Production Zabbix HA Stack.

---

# Patroni Fails to Start

## Problem

Patroni service fails during startup.

Example:

```text
systemctl status patroni
```

---

## Common Causes

* Invalid YAML syntax
* Incorrect ETCD configuration
* Network connectivity issues
* PostgreSQL already running outside Patroni
* Invalid REST API address
* Incorrect PostgreSQL data directory permissions

---

## Validation

Check Patroni logs:

```bash
journalctl -u patroni -n 50 --no-pager
```

Validate configuration syntax carefully.

---

# Replica Bootstrap Failure

## Problem

Replica nodes fail during bootstrap.

Example:

```text
FATAL: no pg_hba.conf entry for replication connection
```

---

## Cause

Replication access rules are missing from `pg_hba.conf`.

---

## Solution

Allow replication traffic between PostgreSQL nodes.

Example:

```text
host replication replicator NODE1-IP/32 scram-sha-256
host replication replicator NODE2-IP/32 scram-sha-256
host replication replicator NODE3-IP/32 scram-sha-256
```

Add these lines in patroni file and restart the service

---

# VIP Does Not Migrate

## Problem

Keepalived Virtual IP does not move during failover.

---

## Common Causes

* Incorrect network interface name
* Health check script failure
* VRRP multicast issues
* Firewall restrictions

---

## Validation

Check Keepalived status:

```bash
systemctl status keepalived
```

Verify VIP ownership:

```bash
ip addr
```

---

# ETCD Cluster Issues

## Problem

Patroni cluster instability or leader election failures.

---

## Common Causes

* ETCD quorum loss
* Network latency
* Incorrect peer configuration
* Time synchronization issues

---

## Validation

Check ETCD cluster health:

```bash
etcdctl endpoint health --cluster=true
```

---

# Zabbix HA Node Not Switching

## Problem

Standby Zabbix node does not become active.

---

## Validation

Check HA status:

```bash
zabbix_server -R ha_status
```

Verify:

* Shared PostgreSQL connectivity
* Database VIP accessibility
* Zabbix server configuration consistency

---

# HAProxy Backend Marked Down

## Problem

HAProxy removes healthy backend servers.

---

## Common Causes

* Incorrect health check URL
* Nginx service unavailable
* Firewall restrictions
* Slow backend response

---

## Validation

Check HAProxy logs and backend health:

```bash
systemctl status haproxy
```

Test frontend manually:

```bash
curl http://NODE-IP/zabbix.php
```

---

