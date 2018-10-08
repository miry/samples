## API

### Params
- `page`
- `per_page`
- `ids`

### Endpoints

- `/recipes` - return a list of recipes from 1 till 30
- `/recipes?page=1` - - return a list of recipes from 1 till 30
- `/recipes?page=2` - - return a list of recipes from 31 till 60
- `/recipes?page=2&per_page=100` - - return a list of recipes from 101 till 200

## Build

### Local

Compile on local machine

```shell
$ go generate pkg/conf/vsn.go
$ go build cmd/recipes/main.go
```

### Docker

Create a docker image and you can test. Install MacOS dependicies use `brew bundle`.

```shell
$ bin/build
$ docker run -p 8080:8080 -it miry/recipes:<commit id>
$ curl $(docker-machine ip):8080/version
```

## Release

### Heroku

Deploy to Heroku with containter solution: https://devcenter.heroku.com/articles/container-registry-and-runtime.
Install MacOS dependicies use `brew bundle`.

```shell
$ bin/staging
```

## Structure

The project tries to follow the almost standard [go project layout](https://medium.com/golang-learn/go-project-layout-e5213cdcfaa2), below are some highlights:
```
$ tree -dL 2
├── bin
├── cmd
│   └── recipes
├── pkg
│   ├── client
│   ├── conf
│   ├── mod
│   └── service
└── vendor
    └── github.com
```

## Testings

```shell
$ go test -v ./...
```
