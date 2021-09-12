Fyne is not properly working with IOS and Apple silicon.
Need to return later when issues would be solved.

```
fyne package -os ios -appID com.miry.samples.fyne -appBuild 3 -appVersion 0.0.3
ios-deploy -i 00008030-0015304E368B802E --bundle fyne.app --bundle_id com.miry.samples.fyne -v
```


In same time gomobile is more stable:

```
gomobile build -target=ios -bundleid=com.gomobile.basic golang.org/x/mobile/example/basic
ios-deploy --debug --bundle basic.app
```
