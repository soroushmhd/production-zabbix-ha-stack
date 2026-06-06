# Failover Testing

This section describes high availability validation scenarios performed on the environment.

---

# PostgreSQL Primary Failure

## Objective

Validate Patroni automatic leader election and PostgreSQL failover behavior.

---

## Test Procedure

Stop Patroni service on current leader node:

```bash id="h0tk8i"
systemctl stop patroni
```

---

## Expected Result

* Patroni elects a new primary node
* Replicas reconnect automatically
* VIP migrates to new leader node
* Zabbix remains operational

---

# VIP Migration Validation

## Objective

Validate Keepalived Virtual IP migration.

---

## Test Procedure

Check current VIP ownership:

```bash id="0v9s0n"
ip addr
```

Stop Keepalived:

```bash id="y1r8dy"
systemctl stop keepalived
```

---

## Expected Result

* VIP migrates to standby node
* Database connectivity restored automatically

---

# Zabbix HA Validation

## Objective

Validate Zabbix HA automatic node switching.

---

## Test Procedure

Stop active Zabbix node:

```bash id="zw6tvv"
systemctl stop zabbix-server
```

---

## Expected Result

* Standby node becomes active
* Frontend remains available through HAProxy

---

# Frontend Load Balancing Validation

## Objective

Validate HAProxy backend redundancy.

---

## Test Procedure

Stop one frontend node:

```bash id="qjw9v9"
systemctl stop nginx
```

---

## Expected Result

* HAProxy removes failed backend automatically
* Remaining frontend continues serving requests

---

# Observations

* Patroni failover completed successfully
* VIP migration minimized downtime
* Zabbix HA switching worked correctly
* HAProxy health checks behaved as expected
