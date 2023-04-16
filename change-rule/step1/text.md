
Falco has been installed on *Node* `controlplane` and it runs as a service.

It's configured to log to syslog, and this is where the verification for this scenario also looks.

Cause the rule "shell in a container" to log by:

1. creating a new *Pod* image `nginx:alpine`
2. `kubectl exec pod -- sh` into it
3. check the Falco logs contain a related output





<br>

<details><summary>Tip</summary>

<br>

```bash
service falco status
```{{exec}}

```bash
cat /var/log/syslog | grep falco
```{{exec}}


</details>







<br>

<details><summary>Solution</summary>

<br>

```bash
k run pod --image=nginx:alpine
kubectl wait --for=condition=ready pod pod
k exec -it pod -- sh # run "exit"
```{{exec}}

```bash
cat /var/log/syslog | grep falco | grep shell
```{{exec}}


</details>

