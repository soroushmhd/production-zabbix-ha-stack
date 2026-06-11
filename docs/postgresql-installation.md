# PostgreSQL 16 Installation

This section describes the PostgreSQL 16 installation and initial replication configuration for all database nodes.

---

# Prerequisites

* Ubuntu 24.04
* Root or sudo access
* Network connectivity between database nodes

---

# Install PostgreSQL Repository

Run the following commands on all database nodes:

```bash
echo "deb http://apt.postgresql.org/pub/repos/apt noble-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list > /dev/null

curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg

apt update
```

---

# Install PostgreSQL Packages

```bash
apt install postgresql-16 postgresql-client-16 -y
```

---

# Configure PostgreSQL Parameters

Edit:

```bash
/etc/postgresql/16/main/postgresql.conf
```

Important settings:

```ini
listen_addresses='*'
max_connections=500
wal_level=replica
max_wal_senders=10
max_replication_slots=10
```

---
# Example Configuration Files

| File                                 | Description                     |
| ------------------------------------ | ------------------------------- |
| `configs/postgresql/postgresql.conf` | PostgreSQL main configuration   |

---

---

# Create Replication User

Connect to Database

```bash
sudo -u postgres psql

```
Create a replicator user on each database nodes

```sql
ALTER USER postgres WITH PASSWORD 'CHANGE_ME';
CREATE USER replicator REPLICATION LOGIN ENCRYPTED PASSWORD 'CHANGE_ME';
```

Exit from database

```sql
\q
```

---

# Restart PostgreSQL

```bash
systemctl restart postgresql
```

---

# Validation

Check PostgreSQL status:

```bash
systemctl status postgresql
```

# Next Step

Continue with PostgreSQL installation:

`docs/patroni-installation.md`
