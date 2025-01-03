
Please read the official documentation to get a better overview of what Falco is capable of:
https://falco.org/docs


<br>

In this environment, you have a Kubernetes cluster with a Pod named "test" with a container "b01" that is trying to access memory.
The task is to create a Falco Rule to alert of this behaviour.



### Check if Falco is installed as standalone binary
```plain
which falco
falco --version
```{{exec}}

## Check if nothing else is running/triggering Rules at the moment
```plain
falco -U # wait at least 1 minute and exit the command
```{{exec}}

<br>

```plain
touch /etc/falco/rules.d/custom-rule.yaml
```{{exec}}

### Add the rule to check any container running with access to memory addresses
```yaml
- rule: access_memory
  desc: A process is trying to access prohibited directories
  condition: evt.type = execve and evt.dir = < and (proc.name = devmem or proc.name = mmap or proc.name= mmap2)
  output: Unexpected process trying to access memory on host (command=%proc.cmdline container.id=%container.id container.name=%container.name)
  priority: WARNING
```

### Run Falco and see if the Rule has any effect
```plain
falco -U
```{{exec}}