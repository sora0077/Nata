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

}
