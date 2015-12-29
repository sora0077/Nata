//
//  NataTests.swift
//  NataTests
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import XCTest
@testable import Nata

class NataTests: XCTestCase {
    
    private var document: XMLDocument!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let filePath = NSBundle(forClass: self.dynamicType).pathForResource("atom", ofType: "xml")
        document = try? XMLDocument(data: NSData(contentsOfFile: filePath!)!)
        
        XCTAssertNotNil(document, "")
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
        XCTAssertEqual(document.rootElement?.tag, "feed", "root element should be feed")
    }
    
    func testTitle() {
        
        let titleElement = document.rootElement?.firstChild(tag: "title")
        
        XCTAssertNotNil(titleElement, "title element should not be nil")
        XCTAssertEqual(titleElement?.tag, "title", "tag should be `title`")
        XCTAssertEqual(titleElement?.stringValue, "Example Feed", "title string value should be 'Example Feed'")
    }
}
