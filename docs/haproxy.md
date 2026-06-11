# HAProxy Configuration

This section describes HAProxy configuration for Zabbix frontend load balancing.

HAProxy distributes incoming traffic between Zabbix frontend nodes and improves frontend availability.

---

# Install HAProxy

Run on the load balancer node:

```bash id="t9w4yn"
apt install software-properties-common -y

add-apt-repository ppa:vbernat/haproxy-3.2 -y

apt update

apt install haproxy -y
```

---

# Validate Installation

```bash id="9r3gbm"
haproxy -v
```

---

# Main Configuration File

```bash id="i57ryp"
/etc/haproxy/haproxy.cfg
```

---

# Example Configuration

```cfg id="zbxslx"
global
    log /dev/log local0
    maxconn 4096
    user haproxy
    group haproxy

defaults
    log global
    mode http
    option httplog
    option dontlognull
    retries 3
    timeout connect 5s
    timeout client 50s
    timeout server 50s
    timeout http-request 10s

frontend zabbix_frontend
    bind *:80
    mode http
    option forwardfor
    default_backend zabbix_servers

backend zabbix_servers
    mode http
    balance roundrobin
    option httpchk GET /zabbix.php

    server zabbix-node1 NODE1-IP:80 check fall 3 rise 2
    server zabbix-node2 NODE2-IP:80 check fall 3 rise 2
```

Replace `NODE1-IP` and `NODE2-IP` with the actual IP addresses of your Zabbix frontend nodes.

---

# Example Configuration Files

| File                          | Description                                  |
| ----------------------------- | -------------------------------------------- |
| `configs/haproxy/haproxy.cfg` | HAProxy frontend load balancer configuration |


---

# Configuration Overview

| Section            | Purpose                      |
| ------------------ | ---------------------------- |
| frontend           | Accept incoming HTTP traffic |
| backend            | Define Zabbix frontend nodes |
| balance roundrobin | Distribute traffic evenly    |
| check              | Enable backend health checks |
| `check fall 3 rise 2` | Mark node down after 3 failed checks, up after 2 successful checks |

---

# Start HAProxy

```bash id="d61b5f"
systemctl restart haproxy
```

Enable automatic startup:

```bash id="h9z93v"
systemctl enable haproxy
```

---

# Validate HAProxy

Check service status:

```bash id="m2d2dc"
systemctl status haproxy
```

Verify frontend accessibility:

```bash id="kl3xgk"
curl http://LOADBALANCER-IP/zabbix.php
```

---

# Failover Testing

Stop one frontend node:

```bash id="mjlwm1"
systemctl stop nginx
```

Expected result:

* HAProxy automatically removes failed node
* Remaining node continues serving requests

---

# Notes

* Health checks are critical for automatic backend removal
* Round-robin balancing provides simple traffic distribution
* Timeouts should be tuned for production workloads

---

## Production Considerations

This guide demonstrates a **single-node HAProxy** setup for **educational purposes**.

**For production environments:**
- Deploy at least 2 HAProxy nodes with Keepalived (floating IP)
- Ensure HAProxy itself is highly available to avoid a single point of failure