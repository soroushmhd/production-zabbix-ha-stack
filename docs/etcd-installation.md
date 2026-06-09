# ETCD Installation and Configuration

This section describes the ETCD distributed cluster configuration used by Patroni for PostgreSQL leader election and cluster state management.

---

# Install ETCD

Run on all database nodes:

```bash id="5czw88"
apt install etcd-server etcd-client
```

---

# Configure ETCD

Edit:

```bash id="9bb7d0"
/etc/default/etcd
```

Configure:

* Client URLs
* Peer URLs
* Cluster nodes
* Initial cluster state

---

# Example Configuration Files

| File                           | Description                  |
| ------------------------------ | ---------------------------- |
| `configs/etcd/etcd-node1.conf` | ETCD configuration for node1 |
| `configs/etcd/etcd-node2.conf` | ETCD configuration for node2 |
| `configs/etcd/etcd-node3.conf` | ETCD configuration for node3 |

---

# Start ETCD

```bash id="v9hr9k"
systemctl enable --now etcd
```

---

# Verify Cluster Health

```bash id="3r0s4i"
etcdctl endpoint health --cluster=true
```

---

# Validation

Verify all ETCD members are healthy and reachable before continuing with Patroni deployment.

---

# Notes

* ETCD consistency and network stability are critical for reliable Patroni failover behavior
* Time synchronization between nodes is strongly recommended
* ETCD quorum loss may impact failover operations

---

# Next Step

Continue with PostgreSQL installation:

`docs/postgresql-installation.md`
