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

mkdir /var/falco-test

cat > ./deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: test
  labels:
    app: test
spec:
  replicas: 1
  selector:
    matchLabels:
      app: test
  template:
    metadata:
      labels:
        app: test
    spec:
      volumes:
        - name: files
          hostPath:
            path: /var/falco-test
            readOnly: true
      containers:
      - name: busybox
        image: busybox
        volumeMounts:
          - name: files
            mountPath: /var/falco-test
        command: ["/bin/sh", "-c", "while true; do cat /var/falco-test/h.txt; sleep 10s; done"]
EOF

kubectl apply -f ./deployment.yaml

touch /ks/.k8sfinished
