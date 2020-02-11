# PostreSQL

```
kubectl logs job/postgresql-setup
```

```
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "\du"
PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "\dt"

PGPASSWORD=$PASSWORD psql --host postgresql.$CLUSTER --port 9999 -U postgres -d astroplant -c "SELECT * FROM pg_stat_activity;"
```

Prometheus metrics exporter

```
export POD_NAME=$(kubectl get pods -l app=postgresql -l role=master -o jsonpath='{ .items[0].metadata.name}')
kubectl port-forward $POD_NAME 9187:9187

curl http://localhost:9187/metrics
```

http://localhost:9187/metrics

## DBeaver

https://dbeaver.io/
