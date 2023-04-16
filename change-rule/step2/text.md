
Change the Falco `output` of rule "Terminal shell in container" to:
* include `NEW SHELL!!!` at the very beginning
* include `user_id=%user.uid` at any position
* include `repo=%container.image.repository` at any position

Cause syslog output again by creating a shell in that *Pod*.

Verify the syslogs contain the new data.





<br>

<details><summary>Tip</summary>

https://falco.org/docs/rules/supported-fields

<br>

```bash
cd /etc/falco/

grep -ri "shell in"
```{{exec}}


</details>






<br>

<details><summary>Solution</summary>

<br>

```bash
cd /etc/falco/

cp falco_rules.yaml falco_rules.local.yaml

vim falco_rules.local.yaml
```{{exec}}

<br>

```yaml
- rule: Terminal shell in container
  desc: A shell was used as the entrypoint/exec point into a container with an attached terminal.
  condition: >
    spawned_process and container
    and shell_procs and proc.tty != 0
    and container_entrypoint
    and not user_expected_terminal_shell_in_container_conditions
  output: >
    NEW SHELL!!! (user_id=%user.uid repo=%container.image.repository %user.uiduser=%user.name user_loginuid=%user.loginuid %container.info
    shell=%proc.name parent=%proc.pname cmdline=%proc.cmdline terminal=%proc.tty container_id=%container.id image=%container.image.repository)
  priority: NOTICE
  tags: [container, shell, mitre_execution]
```

<br>

```bash
service falco restart

k exec -it pod -- sh

cat /var/log/syslog | grep falco | grep shell
```{{exec}}


</details>
