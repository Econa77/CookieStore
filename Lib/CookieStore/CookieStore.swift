//
//  CookieStore.swift
//  CookieStore
//
//  Created by 古林　俊祐　 on 2015/10/07.
//  Copyright © 2015年 Shunsuke Furubayashi. All rights reserved.
//

import UIKit

// MARK: - CookieStore
public class CookieStore: NSObject {
    // MARK: - Properties
    public static let sharedStore = CookieStore()
    public var saveDomains = [String]() {
        didSet {
            self.saveCookies()
        }
    }
    private let kCookieStoreSavedHTTPCookiesKey = "kCookieStoreSavedHTTPCookiesKey"
    
    // MARK: - Initialize
    override init() {
        super.init()
        self.loadCookies()
    }
    
    deinit {
        self.removeNotification()
    }
    
    public func setup() {
        self.registApplicationNotification()
    }
}

// MARK: - Control Cookies
public extension CookieStore {
    public func cookieValue(domain: String, name: String) -> String {
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies where cookie.domain == domain && cookie.name == name {
                return cookie.value
            }
        }
        return ""
    }
    
    public func loadCookies() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let cookiesData = defaults.objectForKey(kCookieStoreSavedHTTPCookiesKey) as? NSData {
            if let cookies = NSKeyedUnarchiver.unarchiveObjectWithData(cookiesData) as? [NSHTTPCookie] {
                for cookie in cookies {
                    NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
                }
            }
        }
    }
    
    public func saveCookies() {
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            var savedCookies = [NSHTTPCookie]()
            for cookie in cookies where self.saveDomains.contains(cookie.domain) {
                savedCookies.append(cookie)
            }
            if savedCookies.count != 0 {
                let cookiesData = NSKeyedArchiver.archivedDataWithRootObject(savedCookies)
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(cookiesData, forKey: kCookieStoreSavedHTTPCookiesKey)
                defaults.synchronize()
            }
        } else {
            self.deleteCookies()
        }
    }
    
    public func deleteCookies() {
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
        self.saveCookies()
    }
    
    public func deleteCookie(domain: String) {
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies where cookie.domain == domain {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
        self.saveCookies()
    }
    
    public func deleteCookie(domain: String, name: String, path: String) {
        if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies {
            for cookie in cookies where cookie.domain == domain && cookie.name == name && cookie.path == path {
                NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
            }
        }
        self.saveCookies()
    }
    
    public func addCookie(value: String, name: String, domain: String, path: String, expiresDate: NSDate? = nil) {
        self.deleteCookie(domain, name: name, path: path)
        
        var properties = [String: AnyObject]()
        properties[NSHTTPCookieValue] = value
        properties[NSHTTPCookieName] = name
        properties[NSHTTPCookieDomain] = domain
        properties[NSHTTPCookieExpires] = expiresDate ?? "0"
        properties[NSHTTPCookiePath] = path
        
        if let cookie = NSHTTPCookie(properties: properties) {
            NSHTTPCookieStorage.sharedHTTPCookieStorage().setCookie(cookie)
        }
        self.saveCookies()
    }
}

// MARK: - NSNotification
private extension CookieStore {
    private func registApplicationNotification() {
        let nCenter = NSNotificationCenter.defaultCenter()
        nCenter.addObserver(self, selector: "loadCookies", name: UIApplicationDidBecomeActiveNotification, object: nil)
        nCenter.addObserver(self, selector: "saveCookies", name: UIApplicationDidEnterBackgroundNotification, object: nil)
        nCenter.addObserver(self, selector: "saveCookies", name: UIApplicationWillTerminateNotification, object: nil)
    }
    
    private func removeNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}