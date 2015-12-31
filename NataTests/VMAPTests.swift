//
//  VMAPTests.swift
//  Nata
//
//  Created by 林達也 on 2015/12/31.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import XCTest
import Nata

class VMAPTests: XCTestCase {
    
    private var document: XMLDocument!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let filePath = NSBundle(forClass: self.dynamicType).pathForResource("vmap", ofType: "xml")
        document = try? XMLDocument(data: NSData(contentsOfFile: filePath!)!)
        
        XCTAssertNotNil(document, "Document should not be nil")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAbsoluteXPathWithNamespace() {
        let XPath = "/vmap:VMAP/vmap:Extensions/uo:unicornOnce"
        var count = 0
        for element in document.XPath(XPath) {
            XCTAssertEqual("unicornOnce", element.tag, "tag should be `unicornOnce`")
            count += 1
        }
        
        XCTAssertEqual(1, count, "Element should be found at XPath `\(XPath)`")
    }
    
    func testRelativeXPathWithNamespace() {
        let absoluteXPath = "/vmap:VMAP/vmap:Extensions"
        let relativeXPath = "./uo:unicornOnce"
        var count = 0
        for absoluteElement in document.XPath(absoluteXPath) {
            for relativeElement in absoluteElement.XPath(relativeXPath) {
                XCTAssertEqual("unicornOnce", relativeElement.tag, "tag should be `unicornOnce`")
                count += 1
            }
        }
        
        XCTAssertEqual(1, count, "Element should be found at XPath '\(relativeXPath)' relative to XPath '\(absoluteXPath)'")
    }
    
    func testUnicornOnceIsBlank() {
        let XPath = "/vmap:VMAP/vmap:Extensions/uo:unicornOnce"
        let element = document.firstChild(XPath: XPath)
        XCTAssertNotNil(element)
        XCTAssertEqual(element?.isBlank, true, "Element should be blank")
    }

}
