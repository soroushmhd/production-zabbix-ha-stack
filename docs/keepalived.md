# Keepalived Configuration

This section describes Keepalived configuration for Virtual IP failover between PostgreSQL nodes.

Keepalived ensures database connectivity continuity by automatically moving the VIP to the active PostgreSQL primary node.

---

# Install Keepalived

Run on all database nodes:

```bash id="g9d4df"
apt install keepalived -y
```

---

# Main Configuration File

```bash id="x0rpyz"
/etc/keepalived/keepalived.conf
```

---

# Configure Node1

Example:

```conf id="kzj6wr"
global_defs {
    script_user root
    enable_script_security
}

vrrp_script chk_postgresql {
    script "/etc/keepalived/check_postgresql.sh"
    interval 5
    weight 0
}

vrrp_instance VI_1 {
    state MASTER
    interface ens192
    virtual_router_id 51
    priority 100
    advert_int 1

    authentication {
        auth_type PASS
        auth_pass CHANGE_ME
    }

    virtual_ipaddress {
        VIP-IP/24
    }

    track_script {
        chk_postgresql
    }
}
```

---

# Configure Remaining Nodes

Update:

* state BACKUP
* lower priority values
* interface name
* VIP address

---

# Example Configuration Files

| File                                       | Description                          |
| ------------------------------------------ | ------------------------------------ |
| `configs/keepalived/keepalived-node1.conf` | Keepalived master node configuration |
| `configs/keepalived/keepalived-node2.conf` | Keepalived backup node configuration |


---

# Health Check Script

Create:

```bash id="oz0fpa"
/etc/keepalived/check_postgresql.sh
```

Script:

```bash id="4dg6rm"
#!/bin/bash

if [[ $(curl -s http://localhost:8008/health | grep -c '"role": "primary"') -eq 1 ]]; then
    exit 0
else
    exit 1
fi
```

Make executable:

```bash id="bg4g3h"
chmod +x /etc/keepalived/check_postgresql.sh
```

---

# Start Keepalived

```bash id="ff6ec8"
systemctl restart keepalived
```

Enable automatic startup:

```bash id="mjlwm9"
systemctl enable keepalived
```

---

# Validate VIP

Check active VIP ownership:

```bash id="e0uzmw"
ip addr
```

Expected behavior:

* VIP should exist only on active PostgreSQL primary node
* VIP should migrate automatically during failover

---

# Failover Validation

Stop Patroni on leader node:

```bash id="o0kz95"
systemctl stop patroni
```

Expected result:

* Patroni elects new leader
* Keepalived moves VIP automatically

---

# Notes

* VIP failover depends on Patroni health endpoint
* Incorrect interface names can break VRRP
* Keepalived timing affects client reconnection behavior
