CookieStore
===========

iOSのNSHTTPCookieStrageの管理クラス

## 使用方法
```
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // CookieStoreのセットアップ
    CookieStore.sharedStore.setup()
    // CookieStoreで管理するドメインの配列
    CookieStore.sharedStore.saveDomains = ["clipy-app.com"]

    return true
}

func addCookie() {
    CookieStore.sharedStore.addCookie("testCookie", name: "session", domain: "clipy-app.com", path: "/")
}

func deleteCookie() {
    CookieStore.sharedStore.deleteCookie("clipy-app.com", name: "session", path: "/")
}

func getCookieValue() {
    let userSession = CookieStore.sharedStore.cookieValue("clipy-app.com, name: "session")
}
```

* `saveDomains`に設定したドメインはアプリケーションの起動時、終了時に自動で保存、読み込み処理がかかります
