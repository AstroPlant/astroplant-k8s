# Minikube

## Install and start Minikube

Default:
- virtualbox VM (CPUs=2, Memory=2048MB, Disk=20000MB)
- Kubernetes v1.15.0 on Docker 18.09.6

```
minikube delete
#minikube start
minikube start --cpus 4 --memory 8192 --disk-size 40g
```

```
kubectl config use-context minikube

kubectl get pods --all-namespaces
```

```
minikube dashboard
```

http://127.0.0.1:49842/api/v1/namespaces/kube-system/services/http:kubernetes-dashboard:/proxy/

## NGINX Ingress Controller

https://kubernetes.github.io/ingress-nginx/deploy/#minikube

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml

minikube addons enable ingress

kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx --watch
```

Get external IP address.

```
minikube ip
```

`/ect/hosts`

```
192.168.99.100 lb.astroplant-daphne.sda-projects.nl
192.168.99.100 minio.astroplant-daphne.sda-projects.nl
192.168.99.100 grafana.astroplant-daphne.sda-projects.nl
```

## TCP services

https://skryvets.com/blog/2019/04/09/exposing-tcp-and-udp-services-via-ingress-on-minikube/

```
minikube addons disable ingress
kubectl get deploy nginx-ingress-controller -n ingress-nginx -o yaml |\
  yq w - spec.template.spec.hostNetwork true > nginx-ingress-controller.yaml
kubectl apply -f nginx-ingress-controller.yaml --force
```

## Helm

```
helm init --upgrade

export TILLER_NAMESPACE=kube-system
```
