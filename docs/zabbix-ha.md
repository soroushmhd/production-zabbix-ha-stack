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

Locate the schema file in Zabbix nodes:

```bash
ls /usr/share/zabbix-sql-scripts/postgresql/
```

Install the common package on Zabbix node1

```bash
apt install postgresql-client-common
```

Install the main PostgreSQL client

```bash
apt install postgresql-client-16 -y
```

Import the schema:

```bash
zcat /usr/share/zabbix-sql-scripts/postgresql/server.sql.gz | psql -U zabbix -d zabbix -h DB_VIP
```

---

# Configure Zabbix Server

Edit the configuration file:

```bash
/etc/zabbix/zabbix_server.conf
```

Configure database connectivity using the PostgreSQL VIP:

```ini
DBHost=DB-VIP              # Uncomment and set to your PostgreSQL VIP
DBName=zabbix              # Already set, uncomment if needed
DBUser=zabbix              # Already set, uncomment if needed  
DBPassword=CHANGE_ME       # Uncomment and set the actual password
DBPort=5432                # Already set, uncomment if needed
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

# Example Configuration Files

| File                                      | Description                   |
| ----------------------------------------- | ----------------------------- |
| `configs/zabbix/zabbix_server_node1.conf` | Zabbix HA node1 configuration |
| `configs/zabbix/zabbix_server_node2.conf` | Zabbix HA node2 configuration |

---

> Note:
> Cache-related parameters should be adjusted according to:
>
> - Number of monitored hosts
> - Collected metrics volume
> - Database performance
> - Available server memory
>
> The provided values are example production-style baseline settings.

---

# Configure Web Server (Nginx)

Edit the Nginx configuration on zabbix-node1 and zabbix-node2:

```bash
/etc/zabbix/nginx.conf
```

Example configuration:

```nginx
server {
    listen 80;            # Change to your desired port
    server_name NODE-IP;  # Changed to actual node IP
    .
    .
    .
}
```

# Remove default nginx site

```bash
rm /etc/nginx/sites-enabled/default
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

![Zabbix cluster health check](images/zabbix-ha-status.png)

---

## Zabbix 7.0 Web Frontend Installation

After installing the Zabbix packages and configuring the database, proceed with the web-based installation wizard.

---

### Step 1: Welcome Screen

Navigate to `http://<zabbix-node-ip>` in your browser.

- Select **Default language**: English (en_US)
- Click **Next step**

![Zabbix Welcome Screen](images/zabbix-preinstallation1.png)

---

### Step 2: Prerequisites Check

Verify all requirements are met:

| Parameter | Current Value | Required | Status |
|-----------|---------------|----------|--------|
| PHP version | 8.3.6 | 8.0.0 | ✓ Pass |
| PHP option "memory_limit" | 128M | 128M | ✓ Pass |
| PHP option "post_max_size" | 16M | 16M | ✓ Pass |
| PHP option "upload_max_filesize" | 2M | 2M | ✓ Pass |
| PHP option "max_execution_time" | 300 | 300 | ✓ Pass |
| PHP option "max_input_time" | 300 | 300 | ✓ Pass |
| PHP databases support | PostgreSQL | - | ✓ Pass |
| PHP bcmath | on | - | ✓ Pass |
| PHP mbstring | on | - | ✓ Pass |
| PHP option "mbstring.func_overload" | off | off | ✓ Pass |

**All checks passed** → Click **Next step**

![Prerequisites Check](images/zabbix-preinstallation2.png)

---

### Step 3: Configure Database Connection

Enter your PostgreSQL HA cluster connection details:

| Field | Value |
|-------|-------|
| Database type | PostgreSQL |
| Database host | `DB_VIP` (PostgreSQL VIP) |
| Database port | `5432` |
| Database name | `zabbix` |
| User | `zabbix` |
| Password | `********` (the password set during database creation) |
| Store credentials in | Plain text (or HashiCorp/CyberArk Vault as needed) |
| Database TLS encryption | Configure if required |

**Important:** Use the **PostgreSQL VIP address** (managed by Keepalived) for high availability. This ensures Zabbix automatically reconnects to the new primary node during PostgreSQL failover.

Click **Next step**

![Database Configuration](images/zabbix-preinstallation3.png)

---

### Step 4: Zabbix Server Settings

Configure the following settings:

| Field | Value |
|-------|-------|
| Zabbix server name | `zabbix-node1` (or your preferred name) |
| Default time zone | `(UTC+03:30) Asia/Tehran` (adjust to your location) |
| Default theme | Blue (or your preferred theme) |

Click **Next step**

![Zabbix Settings](images/zabbix-preinstallation4.png)

---

### Step 5: Pre-installation Summary

Review all configuration parameters:

| Parameter | Value |
|-----------|-------|
| Database type | PostgreSQL |
| Database server | DB_VIP |
| Database port | 5432 |
| Database name | zabbix |
| Database user | zabbix |
| Database password | ****** |
| Database schema | false |
| Zabbix server name | zabbix-node1 |

**If everything is correct** → Click **Next step**

![Pre-installation Summary](images/zabbix-preinstallation5.png)

---

### Step 6: Installation Complete

You will see the success message:

> **Congratulations! You have successfully installed Zabbix frontend.**
>
> Configuration file `conf/zabbix.conf.php` created.

Click **Finish** to complete the installation.

![Installation Complete](images/zabbix-preinstallation6.png)

---

### Step 7: Login to Zabbix

After installation, log in to the Zabbix frontend:

- **Username:** `Admin` (case-sensitive, capital 'A')
- **Password:** `zabbix` (all lowercase)

**Important:** You will be prompted to change the default password upon first login.

---

### Post-Installation: Generated Configuration File

The installer creates `/etc/zabbix/web/zabbix.conf.php`. This file contains the database connection settings and must be identical on both Zabbix frontend nodes for proper HA operation.

To configure the second node, choose one of the following methods:

| Method | Command / Steps |
|--------|-----------------|
| **Copy from node1** | `scp /etc/zabbix/web/zabbix.conf.php zabbix-node2:/etc/zabbix/web/` |
| **Repeat web installer** | Run the web installation wizard on `zabbix-node2` using the same database credentials |


## Validate Zabbix HA Status from Web UI

After successfully configuring Zabbix High Availability nodes, you can verify the HA cluster status directly from the Zabbix frontend.

### Access HA Status Dashboard

1. Log in to the Zabbix frontend as **Admin** user
2. Navigate to **Reports** → **System information** 

![Validate HA Zabbix from web](images/zabbix-ha-webui.png)


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


# Next Step

Continue with HAProxy configuration:

`docs/haproxy.md`