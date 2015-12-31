//
//  AtomTests.swift
//  NataTests
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import XCTest
@testable import Nata

class AtomTests: XCTestCase {
    
    private var document: XMLDocument!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let filePath = NSBundle(forClass: self.dynamicType).pathForResource("atom", ofType: "xml")
        document = try? XMLDocument(data: NSData(contentsOfFile: filePath!)!)
        
        document.definePrefix("atom", forDefaultNamespace: "http://www.w3.org/2005/Atom")
        
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
        XCTAssertEqual(document.rootElement.tag, "feed", "root element should be feed")
    }
    
    func testTitle() {
        
        let titleElement = document.rootElement.firstChild(tag: "title")
        
        XCTAssertNotNil(titleElement, "title element should not be nil")
        XCTAssertEqual(titleElement?.tag, "title", "tag should be `title`")
        XCTAssertEqual(titleElement?.stringValue, "Example Feed", "title string value should be 'Example Feed'")
    }
    
    func testXPathTitle() {
        
        let titleElement = document.rootElement.firstChild(XPath: "/atom:feed/atom:title")
        
        XCTAssertNotNil(titleElement, "title element should not be nil")
        XCTAssertEqual(titleElement?.tag, "title", "tag should be `title`")
        XCTAssertEqual(titleElement?.stringValue, "Example Feed", "title string value should be 'Example Feed'")
    }
    
    func testLinks() {
        
        let linkElements = document.rootElement.children(tag: "link")
        
        XCTAssertEqual(linkElements.count, 2, "should have 2 link elements")
        XCTAssertEqual(linkElements[0].stringValue, "", "stringValue should be nil")
        XCTAssertNotNil(linkElements[0]["href"], "href should not be nil")
        XCTAssertNotEqual(linkElements[0]["href"], linkElements[1]["href"], "href values should not be equal")
    }
    
    func testUpdated() {
        
        let updatedElement = document.rootElement.firstChild(tag: "updated")
        
        XCTAssertNotNil(updatedElement?.dateValue, "dateValue should not be nil")
        
        let dateComponents = NSDateComponents()
        dateComponents.timeZone = NSTimeZone(abbreviation: "UTC")
        dateComponents.year = 2003
        dateComponents.month = 12
        dateComponents.day = 13
        dateComponents.hour = 18
        dateComponents.minute = 30
        dateComponents.second = 2
        
        XCTAssertEqual(updatedElement?.dateValue, NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)?.dateFromComponents(dateComponents), "dateValue should be equal to December 13, 2003 6:30:02 PM")
    }
    
    func testEntries() {
        let entryElements = document.rootElement.children(tag: "entry")
        XCTAssertEqual(entryElements.count, 1, "should be 1 entry element")
    }
    
    func testNamespace() {
        let entryElements = document.rootElement.children(tag: "entry")
        XCTAssertEqual(entryElements.count, 1, "should be 1 entry element")
        
        let namespacedElements = entryElements[0].children(tag: "language", inNamespace: "dc")
        XCTAssertEqual(namespacedElements.count, 1, "should be 1 entry element")
        
        let namespacedElement = namespacedElements[0]
        XCTAssertEqual(namespacedElement.stringValue, "en-us", "the value should match")
        XCTAssertNotNil(namespacedElement.namespace, "the namespace shouldn't be nil")
        XCTAssertEqual(namespacedElement.namespace, "dc", "Namespaces should match")
    }
    
    func testXPathWithNamespaces() {
        
        var count = 0
        document.enumerateElements(XPath: "//dc:language") { element, idx, stop in
            XCTAssertNotNil(element.namespace, "the namespace shouldn't be nil")
            XCTAssertEqual(element.namespace, "dc", "Namespaces should match")
            count = idx + 1
        }
        XCTAssertEqual(count, 1, "should be 1 entry element")
    }
}
