# Minio

Minio object store with a bucket called `images` will be created.

```
mc config host add astroplant https://minio.$CLUSTER/ admin $PASSWORD

mc ls astroplant
mc ls astroplant --recursive
```
