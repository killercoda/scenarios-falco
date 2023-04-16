#!/bin/bash

# this script ensures that k8s is running and working

rm $0

while [ ! -f /root/.kube/config ]
do
  sleep 1
done

until [ `kubectl get nodes | grep -w "Ready" | wc -l` -eq 1 ] ; do
  sleep 1
done

touch /ks/.k8sfinished
