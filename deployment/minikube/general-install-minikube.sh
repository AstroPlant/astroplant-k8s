#!/bin/bash
kubectl config use-context minikube

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml

minikube addons enable ingress

minikube ip


# Tiller
kubectl create serviceaccount --namespace kube-system tiller
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
helm init --service-account tiller --upgrade

export TILLER_NAMESPACE=kube-system
helm init --upgrade


# TCP ports
minikube addons disable ingress
kubectl get deploy nginx-ingress-controller -n ingress-nginx -o yaml |\
  yq w - spec.template.spec.hostNetwork true > nginx-ingress-controller.yaml
kubectl apply -f nginx-ingress-controller.yaml --force

kubectl apply -f tcp-configmap.yaml
