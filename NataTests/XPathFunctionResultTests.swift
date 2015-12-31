//
//  XPathFunctionResultTests.swift
//  Nata
//
//  Created by 林達也 on 2015/12/31.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import XCTest
import Nata

class XPathFunctionResultTests: XCTestCase {
    
    private var document: XMLDocument!

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let filePath = NSBundle(forClass: self.dynamicType).pathForResource("atom", ofType: "xml")
        document = try? XMLDocument(data: NSData(contentsOfFile: filePath!)!)
        
        document.definePrefix("atom", forDefaultNamespace: "http://www.w3.org/2005/Atom")
        
        XCTAssertNotNil(document, "Document should not be nil")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testFunctionResultBoolVaule() {
        let XPath = "starts-with('Ono','O')"
        let result = document.rootElement.functionResultByEvaluatingXPath(XPath)
        XCTAssertEqual(result?.boolValue, true, "Result boolVaule should be true")
    }

    func testFunctionResultNumericValue() {
        let XPath = "count(./atom:link)"
        let result = document.rootElement.functionResultByEvaluatingXPath(XPath)
        XCTAssertEqual(result?.numericValue, 2, "Number of child links should be 2")
    }

    func testFunctionResultStringVaule() {
        let XPath = "string(./atom:entry[1]/dc:language[1]/text())"
        let result = document.rootElement.functionResultByEvaluatingXPath(XPath)
        XCTAssertEqual(result?.stringValue, "en-us", "Result stringValue should be `en-us`")
    }
}
