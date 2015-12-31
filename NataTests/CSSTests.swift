//
//  CSSTests.swift
//  Nata
//
//  Created by 林達也 on 2015/12/31.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import XCTest
@testable import Nata

class CSSTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCSSWildcardSelector() {
        XCTAssertEqual(XPathFromCSS("*"), ".//*")
    }
    
    func testCSSElementSelector() {
        XCTAssertEqual(XPathFromCSS("div"), ".//div")
    }
    
    func testCSSClassSelector() {
        XCTAssertEqual(XPathFromCSS(".highlighted"), ".//*[contains(concat(' ',normalize-space(@class),' '),' highlighted ')]")
    }
    
    func testCSSElementAndClassSelector() {
        XCTAssertEqual(XPathFromCSS("span.highlighted"), ".//span[contains(concat(' ',normalize-space(@class),' '),' highlighted ')]")
    }
    
    func testCSSElementAndIDSelector() {
        XCTAssertEqual(XPathFromCSS("h1#logo"), ".//h1[@id = 'logo']")
    }
    
    func testCSSIDSelector() {
        XCTAssertEqual(XPathFromCSS("#logo"), ".//*[@id = 'logo']")
    }
    
    func testCSSWildcardChildSelector() {
        XCTAssertEqual(XPathFromCSS("html *"), ".//html//*")
    }
    
    func testCSSDescendantCombinatorSelector() {
        XCTAssertEqual(XPathFromCSS("body p"), ".//body/descendant::p")
    }
    
    func testCSSChildCombinatorSelector() {
        XCTAssertEqual(XPathFromCSS("ul > li"), ".//ul/li")
    }
    
    func testCSSAdjacentSiblingCombinatorSelector() {
        XCTAssertEqual(XPathFromCSS("h1 + p"), ".//h1/following-sibling::*[1]/self::p")
    }
    
    func testCSSGeneralSiblingCombinatorSelector() {
        XCTAssertEqual(XPathFromCSS("p ~ p"), ".//p/following-sibling::p")
    }
    
    func testCSSMultipleExpressionSelector() {
        XCTAssertEqual(XPathFromCSS("img[alt]"), ".//img[@alt]")
    }
//    
//    func testCSSAttributeContainsValueSelector() {
//        XCTAssertEqual(XPathFromCSS("i[href~=\"icon\"]"), "//i[contains(concat(' ', @class, ' '),concat(' ', 'icon', ' '))]")
//    }
//    
//    func testCSSAttributeBeginsWithValueSelector() {
//        XCTAssertEqual(XPathFromCSS("a[href|=\"https://\"]"), "//a[@href = 'https://' or starts-with(@href, concat('https://', '-'))]")
//    }
}
