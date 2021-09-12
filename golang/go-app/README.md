Tutorial: https://go-app.dev/start

Run command from the root of the repo:

```shell
go get -u -v github.com/maxence-charriere/go-app/v9@a26b536
mkdir -p web
GOARCH=wasm GOOS=js go build -o web/app.wasm ./golang/go-app/main.go
go build -o goapp_server ./golang/go-app/main.go
./goapp_server
```
