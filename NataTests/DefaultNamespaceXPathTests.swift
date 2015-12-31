//
//  DefaultNamespaceXPathTests.swift
//  Nata
//
//  Created by 林達也 on 2015/12/31.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import XCTest
import Nata

class DefaultNamespaceXPathTests: XCTestCase {
    
    private var document: XMLDocument!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let filePath = NSBundle(forClass: self.dynamicType).pathForResource("ocf", ofType: "xml")
        document = try? XMLDocument(data: NSData(contentsOfFile: filePath!)!)
        
        XCTAssertNotNil(document, "Document should not be nil")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAbsoluteXPathWithDefaultNamespace() {
        
        document.definePrefix("ocf", forDefaultNamespace: "urn:oasis:names:tc:opendocument:xmlns:container")
        let XPath = "/ocf:container/ocf:rootfiles/ocf:rootfile"
        var count = 0
        for element in document.XPath(XPath) {
            XCTAssertEqual("rootfile", element.tag, "tag should be `rootfile`")
            count += 1
        }
        
        XCTAssertEqual(1, count, "Element should be found at XPath '\(XPath)'")
    }

    func testRelativeXPathWithDefaultNamespace() {
        
        document.definePrefix("ocf", forDefaultNamespace: "urn:oasis:names:tc:opendocument:xmlns:container")
        let absoluteXPath = "/ocf:container/ocf:rootfiles"
        let relativeXPath = "./ocf:rootfile"
        var count = 0
        for absoluteElement in document.XPath(absoluteXPath) {
            for relativeElement in absoluteElement.XPath(relativeXPath) {
                XCTAssertEqual("rootfile", relativeElement.tag, "tag should be `rootfile`")
                count += 1
            }
        }
        
        XCTAssertEqual(1, count, "Element should be found at XPath '\(relativeXPath)' relative to XPath '\(absoluteXPath)'")
    }
}
