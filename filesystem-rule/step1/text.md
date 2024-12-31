
Please read the official documentation to get a better overview of what Falco is capable of:
https://falco.org/docs


<br>

In this environment, you have a Kubernetes cluster with a Pod named "test" with a volume mounted on hostPath /var/falco-test.
The task is to create a Falco Rule to alert of this behaviour.



## Check if Falco is installed as standalone binary
```plain
which falco
falco version
```{{exec}}

## Check if nothing else is running/triggering Rules at the moment
```plain
falco -u # wait at least 1 minute and exit the command
```{{exec}}

<br>

## In a new file called "filesystem-rule.yaml" inside /etc/falco/rules.d/, create the list of directories that we want to check, for this example only include /var/falco-test
```yaml
- list: file_operation_paths
  items: [/var/falco-test]
```

## Add the rule to check any container running
```yaml
- rule: Get containers accesing /var/falco-test
  desc: An attempt to access /var/falco-test directory
  condition: (evt.type in (open,openat,openat2)) and fd.name startswith file_operation_paths
  output: >
    Some File related operation on Path (evt.type=%evt.type path=%fs.path.name source=%fs.path.source container-id=%container.id container-name=%container.name)
  priority: WARN
  source: syscall
```

## Run Falco and see if the Rule has any effect
```plain
falco -u
```{{exec}}