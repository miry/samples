## Toxiproxy

### Setup

```shell
$ kind create cluster --config=cluster.yml
$ kubectl apply -f resources.yml
$ psql -h 127.0.0.1 -U postgres -c "DROP DATABASE IF EXISTS sample; CREATE DATABASE sample"
```
