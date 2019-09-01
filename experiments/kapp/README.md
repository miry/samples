Depploy app with kapp
=====================

### Install

Check for latest release in [Github](https://github.com/k14s/kapp/releases).

```shell
$ wget -O bin/kapp https://github.com/k14s/kapp/releases/download/v0.11.0/kapp-linux-amd64
$ chmod +x bin/kapp
$ kapp version
Client Version: 0.11.0

Succeeded
```

### Deploy app

The feature that missed in original kubernetes, to see the diff before apply.
Deploy command consists of two stages: resource "diff" stage, and resource "apply" stage.

```shell
$ kapp deploy -a 2048 -f experiments/kapp/2048/

Changes

Namespace  Name             Kind        Conds.  Age  Op      Wait to  
-          2048-game        Namespace   -       -    create  reconcile  
2048-game  2048-deployment  Deployment  -       -    create  reconcile  
~          service-2048     Service     -       -    create  reconcile  

Op:      3 create, 0 delete, 0 update, 0 noop
Wait to: 3 reconcile, 0 delete, 0 noop

Continue? [yN]: y

8:42:46PM: ---- applying 1 changes [0/3 done] ----
8:42:46PM: create namespace/2048-game (v1) cluster
8:42:46PM: ---- waiting on 1 changes [0/3 done] ----
....
8:43:06PM: ---- applying complete [3/3 done] ----
8:43:06PM: ---- waiting complete [3/3 done] ----

Succeeded
```

