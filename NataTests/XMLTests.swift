//
//  XMLTests.swift
//  Nata
//
//  Created by 林達也 on 2015/12/31.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import XCTest
import Nata

class XMLTests: XCTestCase {
    
    private var document: XMLDocument!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let filePath = NSBundle(forClass: self.dynamicType).pathForResource("xml", ofType: "xml")
        document = try? XMLDocument(data: NSData(contentsOfFile: filePath!)!)
        
        XCTAssertNotNil(document, "Document should not be nil")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testXMLVersion() {
        XCTAssertEqual(document.version, "1.0", "XML version should be 1.0")
    }
    
    func testXMLEncoding() {
        XCTAssertEqual(document.stringEncoding, NSUTF8StringEncoding, "XML encoding should be UTF-8")
    }

    func testRootElement() {
        XCTAssertEqual(document.rootElement.tag, "spec", "root element should be spec")
        XCTAssertEqual(document.rootElement.attributes["w3c-doctype"], "rec", "w3c-doctype should be rec")
        XCTAssertEqual(document.rootElement.attributes["lang"], "en", "xml:lang should be en")
    }
    
    func testTitle() {
        let titleElement = document.rootElement.firstChild(tag: "header")?.firstChild(tag: "title")
        
        XCTAssertNotNil(titleElement, "title element should not be nil")
        XCTAssertEqual(titleElement?.tag, "title", "tag should be `title`")
        XCTAssertEqual(titleElement?.stringValue, "Extensible Markup Language (XML)", "title string value should be `Extensible Markup Language (XML)`")
    }
}
