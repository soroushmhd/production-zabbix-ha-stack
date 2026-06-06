# ETCD Installation and Configuration

This section describes the ETCD distributed cluster configuration used by Patroni for PostgreSQL leader election and cluster state management.

---

# Install ETCD

Run on all database nodes:

```bash
apt install etcd-server etcd-client
```

---

# Configure ETCD

Edit:

```bash
/etc/default/etcd
```

Configure:

* Client URLs
* Peer URLs
* Cluster nodes
* Initial cluster state

---

# Start ETCD

```bash
systemctl enable --now etcd
```

---

# Verify Cluster Health

```bash
etcdctl endpoint health --cluster=true
```

---

# Notes

ETCD consistency and network stability are critical for reliable Patroni failover behavior.
