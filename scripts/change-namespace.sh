#!/usr/bin/env sh

kubectl config set-context $(kubectl config current-context) --namespace=netbox
# Validate it
kubectl config view | grep namespace:
