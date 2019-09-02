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

### Deploy stateless app

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
...
8:43:06PM: ---- applying complete [3/3 done] ----
8:43:06PM: ---- waiting complete [3/3 done] ----

Succeeded
```

With next command we should see a list of deployed apps:

```shell
$ kapp ls                                      
Apps in namespace 'default'

Name  Label                                 Namespaces           Last Change Successful  Last Change Age  
2048  kapp.k14s.io/app=1567363343492410407  2048-game,<cluster>  true                    4m  

1 apps

Succeeded
```

It looks a bit not correct. I created inside namespace `2048-game`, but app is existing in namespace `default`.
TODO: Investigate how kapp manage apps.

### Modify

Let's change number of replicas in deployemnt and apply changes:

```shell
$ # Modify experiments/kapp/2048/
$ kapp deploy -a 2048 -f experiments/kapp/2048/
Changes

Namespace  Name             Kind        Conds.  Age  Op      Wait to  
2048-game  2048-deployment  Deployment  1/1 ok  18m  update  reconcile  

Op:      0 create, 0 delete, 1 update, 0 noop
Wait to: 1 reconcile, 0 delete, 0 noop

Continue? [yN]: y
9:01:53PM: ---- applying 1 changes [0/1 done] ----
9:01:53PM: update deployment/2048-deployment (extensions/v1beta1) namespace: 2048-game
...
9:02:06PM: ---- applying complete [1/1 done] ----
9:02:06PM: ---- waiting complete [1/1 done] ----

Succeeded
```

It does not show the resource's content difference, just wich resources will be modified.

### 
