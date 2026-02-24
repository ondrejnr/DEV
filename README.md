# Kubernetes Infrastructure Project

Automated Kubernetes infrastructure on Debian Bookworm, managed with Ansible. Deploys a single-node K8s cluster with monitoring (Prometheus, Grafana, Alertmanager), Nginx web/proxy servers, a 5-node etcd cluster, and a health-checker daemon.

## Prerequisites

- Debian Bookworm (amd64)
- `ansible` installed (`sudo apt-get install -y ansible`)
- Root or sudo access

## Quick Start

```bash
sudo apt-get install -y ansible
sudo ansible-playbook playbooks/site.yml
```

## Services

| Service | NodePort | Notes |
|---|---|---|
| Prometheus | 30090 | Metrics & alerting |
| Grafana | 30030 | Dashboards (admin/admin) |
| Alertmanager | 30093 | Alert routing |
| Nginx Web | 30081 | Static webserver |
| Nginx Proxy HTTP | 30080 | Redirects to HTTPS |
| Nginx Proxy HTTPS | 30443 | SSL/TLS reverse proxy + cache |
| Etcd | 30379 | 5-node etcd cluster |

## Verification

```bash
# Check all pods
kubectl get pods -A

# Nginx webserver
curl http://localhost:30081/

# Nginx proxy (HTTPS with self-signed cert)
curl -k https://localhost:30443/

# Prometheus
curl http://localhost:30090/-/ready

# Alertmanager
curl http://localhost:30093/-/healthy

# Etcd health
curl http://localhost:30379/health
```

## Fault Tolerance Test (Etcd)

The etcd cluster runs 5 nodes and tolerates 2 simultaneous failures.

```bash
# Scale down to 3 nodes (simulate 2 failures)
kubectl scale statefulset/etcd -n database --replicas=3

# Verify etcd still works with quorum
kubectl exec -n database etcd-0 -- etcdctl \
  --endpoints=http://etcd-0.etcd-headless.database.svc:2379 \
  put /fault "ok"

# Scale back to 5
kubectl scale statefulset/etcd -n database --replicas=5
```

## Requirements Checklist

- [x] Docker/Kubernetes containers on Debian Bookworm
- [x] Prometheus + node-exporter + nginx-exporter metrics
- [x] **BONUS** Grafana dashboards
- [x] **BONUS2** Alertmanager with alert rules
- [x] Nginx webserver (NodePort 30081)
- [x] Nginx reverse proxy + cache (NodePort 30080/30443)
- [x] **BONUS** Keepalive upstream connections
- [x] **BONUS2** SSL/TLS (TLSv1.2+, strong ciphers, HSTS)
- [x] Etcd 5-node cluster (tolerates 2 failures)
- [x] Daemon with daemontools (svscanboot + svstat)
- [x] **BONUS** multilog log rotation
- [x] Load metrics + nginx stub_status collection
- [x] Human-readable output format (key=value pairs)
- [x] Ansible automation (single `ansible-playbook` command)
- [x] Single-node Kubernetes cluster (kubeadm)
