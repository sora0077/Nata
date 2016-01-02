//
//  HTMLTests.swift
//  Nata
//
//  Created by 林達也 on 2016/01/02.
//  Copyright © 2016年 jp.sora0077. All rights reserved.
//

import XCTest
import Nata

class HTMLTests: XCTestCase {
    
    private var document: XMLDocument!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let filePath = NSBundle(forClass: self.dynamicType).pathForResource("web", ofType: "html")
        document = try? XMLDocument.HTMLDocument(data: NSData(contentsOfFile: filePath!)!)
        
        XCTAssertNotNil(document, "Document should not be nil")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testRootElement() {
        XCTAssertEqual(document.rootElement.tag, "html", "html not root element")
    }

    func testRootElementChildren() {
        let children = document.rootElement.children
        XCTAssertEqual(children.count, 2, "root element has more than two children")
        XCTAssertEqual(children.first?.tag, "head", "head not first child of html")
        XCTAssertEqual(children.last?.tag, "body", "body not last child of html")
    }
    
    func testTitleXPath() {
        var idx = 0
        for element in document.XPath("//head/title") {
            XCTAssertEqual(idx, 0, "more than one element found")
            XCTAssertEqual(element.stringValue, "mattt/Ono", "title mismatch")
            idx += 1
        }
        XCTAssertEqual(idx, 1, "fewer than one element found")
    }
    
    func testTitleCSS() {
        var idx = 0
        for element in document.CSS("head title") {
            XCTAssertEqual(idx, 0, "more than one element found")
            XCTAssertEqual(element.stringValue, "mattt/Ono", "title mismatch")
            idx += 1
        }
        XCTAssertEqual(idx, 1, "fewer than one element found")
    }
    
    func testIDCSS() {
        var idx = 0
        for element in document.CSS("#account_settings") {
            XCTAssertEqual(idx, 0, "more than one element found")
            XCTAssertEqual(element["href"], "/settings/profile", "href mismatch")
            idx += 1
        }
        XCTAssertEqual(idx, 1, "fewer than one element found")
    }
    
    func testReturnsErrorWithNilHTMLDocument() {
        do {
            document = try XMLDocument.HTMLDocument(data: nil)
            XCTFail("error shoud not be nil")
        } catch NataError.ParseError {
            
        } catch {
            XCTFail("error should be NataError.ParseError \(error)")
        }
    }
}
