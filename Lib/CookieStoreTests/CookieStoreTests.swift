//
//  CookieStoreTests.swift
//  CookieStoreTests
//
//  Created by 古林　俊祐　 on 2015/10/07.
//  Copyright © 2015年 Shunsuke Furubayashi. All rights reserved.
//

import XCTest
@testable import CookieStore

class CookieStoreTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        CookieStore.sharedStore.setup()
        CookieStore.sharedStore.saveDomains = ["clipy-app.com"]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDeleteAllCookies() {
        CookieStore.sharedStore.deleteCookies()
        let cookieCount = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies?.count ?? 0
        XCTAssertEqual(cookieCount, 0)
    }
    
    func testAddCookie() {
        CookieStore.sharedStore.deleteCookies()
        
        CookieStore.sharedStore.addCookie("testCookie", name: "user_session", domain: "clipy-app.com", path: "/")
        let userSession = CookieStore.sharedStore.cookieValue("clipy-app.com", name: "user_session")
        XCTAssertEqual(userSession, "testCookie")
        
        let cookieCount = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies?.count ?? 0
        XCTAssertEqual(cookieCount, 1)
    }
    
    func testDeleteCookie() {
        CookieStore.sharedStore.addCookie("testCookie", name: "user_session", domain: "clipy-app.com", path: "/")
        let userSession = CookieStore.sharedStore.cookieValue("clipy-app.com", name: "user_session")
        XCTAssertEqual(userSession, "testCookie")
        
        CookieStore.sharedStore.deleteCookie("clipy-app.com", name: "user_session", path: "/")
        let deleteSession = CookieStore.sharedStore.cookieValue("clipy-app.com", name: "user_session")
        XCTAssertEqual(deleteSession, "")
    }
}
