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

defaults
    log global
    option httplog

frontend zabbix_frontend
    bind *:80
    mode http
    default_backend zabbix_servers

backend zabbix_servers
    mode http
    balance roundrobin

    server zabbix-node1 NODE1-IP:80 check
    server zabbix-node2 NODE2-IP:80 check
```

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
curl http://LOADBALANCER-IP
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
