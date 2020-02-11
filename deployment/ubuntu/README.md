# SSH bastion pod

```
export POD_NAME=$(kubectl get pods -l app=ubuntu -o jsonpath='{ .items[0].metadata.name}')
kubectl exec -it $POD_NAME bash

ssh -i private.pem root@ubuntu.$CLUSTER -p 9997
ssh root@ubuntu.$CLUSTER -p 9997
```

Add other public keys like this:

```
export POD_NAME=$(kubectl get pods -l app=ubuntu -o jsonpath='{ .items[0].metadata.name}')
kubectl cp public.key $POD_NAME:/root/.
kubectl exec -it $POD_NAME -- bash -c "cat /root/public.key >> /root/.ssh/authorized_keys"
```
