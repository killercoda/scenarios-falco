#!/bin/bash

kubectl run pod --image=nginx:alpine

kubectl wait --for=condition=ready pod pod

sleep 1

kubectl exec -it pod -- sh -c 'exit'


cat > /etc/falco/falco_rules.local.yaml <<EOF
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
EOF

service falco restart

sleep 5

kubectl exec -it pod -- sh -c 'exit'
