# Zabbix 7.0 High Availability Setup

This section describes Zabbix 7.0 High Availability configuration using a PostgreSQL HA cluster backend with Patroni, ETCD, Keepalived, and HAProxy.

---

# Architecture Overview

The environment includes:

* 2 Zabbix frontend/application nodes
* PostgreSQL HA cluster managed by Patroni
* ETCD distributed configuration store
* Keepalived virtual IP for PostgreSQL failover
* HAProxy frontend load balancing
* Automatic database and application failover

---

# Install Zabbix 7.0 Repository

Run on all Zabbix application nodes:

```bash
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.0+ubuntu24.04_all.deb

dpkg -i zabbix-release_latest_7.0+ubuntu24.04_all.deb

apt update
```

---

# Install Zabbix 7.0 Packages

```bash
apt install zabbix-server-pgsql zabbix-frontend-php php8.3-pgsql zabbix-nginx-conf zabbix-sql-scripts zabbix-agent -y
```

---

# Create Zabbix Database

Run on the PostgreSQL primary node:

```bash
sudo -u postgres createuser --pwprompt zabbix

sudo -u postgres createdb -O zabbix zabbix
```

---

# Import Initial Zabbix 7.0 Schema

Locate the schema file:

```bash
ls /usr/share/zabbix-sql-scripts/postgresql/
```

Import the schema:

```bash
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | psql -U zabbix -d zabbix -h 127.0.0.1
```

---

# Configure Zabbix Server

Edit the configuration file:

```bash
/etc/zabbix/zabbix_server.conf
```

Configure database connectivity using the PostgreSQL VIP:

```ini
DBHost=VIP-IP
DBName=zabbix
DBUser=zabbix
DBPassword=CHANGE_ME
DBPort=5432
```

---

# Configure Zabbix 7.0 HA Nodes

Zabbix 7.0 supports native High Availability mode.

Configure the following parameters on each node.

Node1:

```ini
HANodeName=zabbix-node1
NodeAddress=NODE1-IP:10051
```

Node2:

```ini
HANodeName=zabbix-node2
NodeAddress=NODE2-IP:10051
```

---

# Configure PHP Frontend

Edit the Nginx configuration:

```bash
/etc/zabbix/nginx.conf
```

Example configuration:

```nginx
server {
    listen 80;
    server_name NODE-IP;

    root /usr/share/zabbix;

    index index.php;
}
```

---

# Start Zabbix Services

```bash
systemctl restart zabbix-server zabbix-agent nginx php8.3-fpm
```

Enable services at boot:

```bash
systemctl enable zabbix-server zabbix-agent nginx php8.3-fpm
```

---

# Validate Zabbix Server Status

Check service status:

```bash
systemctl status zabbix-server
```

Check logs:

```bash
tail -f /var/log/zabbix/zabbix_server.log
```

---

# Validate Zabbix HA Status

Run:

```bash
zabbix_server -R ha_status
```

Expected result:

* One node in active state
* One node in standby state

Example:

```text
Node zabbix-node1: active
Node zabbix-node2: standby
```

---

# Validate Frontend Access

Access the frontend through HAProxy:

```bash
http://LOADBALANCER-IP
```

Complete the initial Zabbix web installation wizard if required.

---

# Failover Validation

Stop the active Zabbix server node:

```bash
systemctl stop zabbix-server
```

Expected result:

* Standby node automatically becomes active
* Frontend remains accessible through HAProxy
* Monitoring continues without interruption

---

# PostgreSQL Failover Validation

Simulate PostgreSQL primary failure:

```bash
systemctl stop patroni
```

Expected result:

* Patroni elects a new PostgreSQL leader
* Keepalived migrates the VIP
* Zabbix reconnects automatically using the VIP

---

# Notes

* Zabbix 7.0 native HA requires a shared PostgreSQL backend
* Patroni manages PostgreSQL automatic failover
* Keepalived provides seamless VIP migration
* HAProxy improves frontend availability and load balancing
* ETCD stores Patroni cluster state information
