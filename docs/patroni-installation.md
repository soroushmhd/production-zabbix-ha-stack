# Patroni Installation and Configuration

This section describes Patroni installation and PostgreSQL cluster configuration.

Patroni is responsible for PostgreSQL high availability, automatic failover and leader election using ETCD.

---

# Prerequisites

Before configuring Patroni:

* PostgreSQL must be installed
* ETCD cluster must be healthy
* Network connectivity between all nodes must exist

---

# Install Patroni

Run on all database nodes:

```bash id="ewq9u2"
apt install patroni -y
```

---

# Create Patroni Configuration File

Create the main Patroni configuration file:

```bash id="0m9v2x"
vim /etc/patroni/config.yml
```

Paste the Patroni cluster configuration into the file.

Example configurations are available in:

* `configs/patroni/node1.yml`
* `configs/patroni/node2.yml`
* `configs/patroni/node3.yml`


---

# Configure Node1

Example configuration:

```yaml id="owm32v"
scope: zabbix
namespace: /db/
name: node1

etcd3:
  hosts:
      - NODE1-IP:2379
      - NODE2-IP:2379
      - NODE3-IP:2379

bootstrap:
  dcs:
    ttl: 30
    retry_timeout: 10

    postgresql:
      use_pg_rewind: true

      parameters:
        max_connections: 500
        wal_level: replica
        max_wal_senders: 10
        max_replication_slots: 10
  initdb:
    - encoding: UTF8
    - data-checksums
  users:
    postgres:
      password: CHANGE_ME
      options:
        - superuser
        - createdb

postgresql:
  listen: 0.0.0.0:5432
  connect_address: NODE1-IP:5432

  data_dir: /var/lib/postgresql/16/main/
  bin_dir: /usr/lib/postgresql/16/bin/

  authentication:
    superuser:
      username: postgres
      password: CHANGE_ME

    replication:
      username: replicator
      password: CHANGE_ME

restapi:
  listen: 0.0.0.0:8008
  connect_address: NODE1-IP:8008

```

---

# Configure Remaining Nodes

Repeat the configuration for:

* node2
* node3

Update:

* node name
* IP address
* REST API address

---

Restart Patroni service

```


```


# Important Parameters

| Parameter       | Description                     |
| --------------- | ------------------------------- |
| scope           | Patroni cluster name            |
| namespace       | ETCD namespace                  |
| ttl             | Leader key lifetime             |
| use_pg_rewind   | Automatic rewind after failover |
| max_wal_senders | Replication connections         |
| restapi         | Patroni API endpoint            |

---

# Remove Existing PostgreSQL Data

Before joining standby nodes:

```bash id="p4c4x8"
rm -rf /var/lib/postgresql/16/main/*
```

> Warning:
> Ensure you are running this command only on standby nodes.

---

# Start Patroni

```bash id="z4vrzi"
systemctl restart patroni
```

Enable automatic startup:

```bash id="s2m5o9"
systemctl enable patroni
```

---

# Validate Cluster Status

```bash id="6a7xfr"
patronictl -c /etc/patroni/config.yml list
```

Expected result:

* One node should be Leader
* Remaining nodes should be Replicas

---

# Validate REST API

```bash id="v1s9k0"
curl http://localhost:8008/health
```

Expected result:

```json id="qblz6v"
{
  "state": "running",
  "role": "primary"
}
```

---

# Notes

* Patroni automatically manages PostgreSQL failover
* ETCD quorum is critical for cluster stability
* Network latency can impact leader election timing
