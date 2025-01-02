
Please read the official documentation to get a better overview of what Falco is capable of:
https://falco.org/docs


<br>

In this environment, you have a Kubernetes cluster with a Pod named "test" with a volume mounted on hostPath /var/falco-test.
The task is to create a Falco Rule to alert of this behaviour.



NOTE: Remember that we're using /etc/falco/rules.d/custom-rule.yaml

### Add the rule to check any container running with access to memory addresses
```yaml
- rule: access_dir
  desc: A process is trying to access prohibited directories
  condition: mkdir or rename or remove or open_write or create_symlink or evt.type in (link, linkat) or evt.type = execve and evt.dir = < or (proc.name = cat or proc.name = grep or proc.name = ls)
  output: File access to prohibited directory (command=%proc.cmdline container.id=%container.id container.name=%container.name)
  priority: WARNING
```

### Run Falco and see if the Rule has any effect
```plain
falco -u
```{{exec}}