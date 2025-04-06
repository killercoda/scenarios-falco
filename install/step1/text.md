
Everything can also be found on:
https://falco.org/docs


<br>

## Install Falco
```plain
curl -s https://falco.org/repo/falcosecurity-packages.asc | apt-key add -
echo "deb https://download.falco.org/packages/deb stable main" | tee -a /etc/apt/sources.list.d/falcosecurity.list
apt-get update -y
apt-get install -y linux-headers-$(uname -r)
apt-get install -y falco=0.40.0
```{{exec}}

```plain
service falco start
service falco status
```{{exec}}

<br>


## Test
```plain
docker run -d --name test nginx:alpine
```{{exec}}

```plain
docker exec -it test sh # run "exit"
```{{exec}}

```plain
cat /var/log/syslog | grep falco
```{{exec}}
