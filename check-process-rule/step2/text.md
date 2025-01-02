
Please read the official documentation to get a better overview of what Falco is capable of:
https://falco.org/docs


<br>

In this environment, you have a Kubernetes cluster with a Pod named "test" with a volume mounted on hostPath /var/falco-test.
The task is to create a Falco Rule to alert of this behaviour.



NOTE: Remember that we're using /etc/falco/rules.d/custom-rule.yaml

### Add the rule to check any container running with access to filesystem paths
```yaml
- list: file_operation_paths
  items: [/var/falco-test]

- macro: file_operation
  condition: evt.type in (mkdir, rename, open, openat)

- rule: access_dir
  desc: Detect any file operation on a single path
  condition: (fs.path.name pmatch (file_operation_paths) or fs.path.source pmatch (file_operation_paths) or fs.path.target pmatch (file_operation_paths)) and file_operation
  output: >
    Some File Related Operation on Path (evt.type=%evt.type path=%fs.path.name source=%fs.path.source
    target=%fs.path.target %user.name=%user.name proc.cmdline=%proc.cmdline proc.pcmdline=%proc.pcmdline
    container.id=%container.id container.name=%container.name image=%container.image.repository)
  priority: DEBUG
  source: syscall
```

### Run Falco and see if the Rule has any effect
```plain
falco -U
```{{exec}}