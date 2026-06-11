# PostgreSQL and Patroni Operational Notes

## PostgreSQL Configuration File Locations

When PostgreSQL is managed by Patroni, configuration files may exist in multiple locations depending on:

* Operating system packaging
* PostgreSQL distribution
* Patroni configuration
* Data directory layout

Common examples:

```text
/etc/postgresql/16/main/postgresql.conf
/var/lib/postgresql/16/main/pg_hba.conf
```

In Patroni-managed clusters, PostgreSQL may load configuration files directly from the data directory instead of `/etc/postgresql/`.

Always verify the active configuration paths using:

```bash
sudo -u postgres psql -c "SHOW config_file;"
sudo -u postgres psql -c "SHOW hba_file;"
```

This is important because editing the wrong configuration file can lead to:

* Replication failures
* Patroni bootstrap failures
* Authentication issues
* Cluster inconsistency

In this environment, replication access rules were managed directly through the Patroni configuration to ensure they are automatically applied and persisted during reloads, failovers, and cluster recovery operations.

---

## PostgreSQL Service Management

When PostgreSQL is managed by Patroni, the PostgreSQL service itself should not be managed manually.

Avoid using:

```bash
systemctl restart postgresql
```

Patroni should control PostgreSQL lifecycle operations including:

* Startup
* Shutdown
* Failover
* Recovery
* Replica bootstrap

Managing PostgreSQL manually can cause:

* Shared memory conflicts
* Patroni state inconsistency
* Replica recovery failures

---

## Operational Lessons Learned

* Always verify active PostgreSQL configuration file locations
* Patroni-managed PostgreSQL behaves differently from standalone PostgreSQL
* Replication access rules are critical for replica bootstrap
