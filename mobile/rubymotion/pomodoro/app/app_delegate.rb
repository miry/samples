class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    rootViewController = TimerController.alloc.init
    rootViewController.title = 'Pomodoro'

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = rootViewController
    @window.rootViewController.wantsFullScreenLayout = true
    @window.makeKeyAndVisible

    true
  end
end
