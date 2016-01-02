//
//  XMLDocument.swift
//  Nata
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation
import Clibxml2

public final class XMLDocument {
    
    public lazy var version: String = lazy {
        if exist(self._xmlDocument.memory.version) {
            return String.fromCString(self._xmlDocument.memory.version)!
        }
        fatalError()
    }
    
    public lazy var stringEncoding: NSStringEncoding = lazy {
        if exist(self._xmlDocument.memory.encoding) {
            let encodingName = String.fromCString(self._xmlDocument.memory.encoding)
            let encoding = CFStringConvertIANACharSetNameToEncoding(encodingName)
            if encoding != kCFStringEncodingInvalidId {
                return CFStringConvertEncodingToNSStringEncoding(encoding)
            }
        }
        return 0
    }
    
    public private(set) var numberFormatter: NSNumberFormatter = lazy {
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        return formatter
    }
    
    public private(set) var dateFormatter: NSDateFormatter = lazy {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }
    
    public var rootElement: XMLElement {
        return _rootElement
    }
    private var _rootElement: XMLElement!
    
    
    private let _xmlDocument: xmlDocPtr
    private(set) var defaultNamespaces: [String: String] = [:]
    
    public convenience init(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        try self.init(data: string.dataUsingEncoding(encoding))
    }
    
    public convenience init(data: NSData?) throws {
        let buffer = data.map { UnsafePointer<Int8>($0.bytes) } ?? nil
        let size = Int32(data?.length ?? 0)
        let document = xmlReadMemory(buffer, size, "", nil, Int32(XML_PARSE_NOWARNING.rawValue | XML_PARSE_NOERROR.rawValue | XML_PARSE_RECOVER.rawValue))
        if empty(document) {
            throw NataError.libxmlGetLastError()
        }
        xmlResetError(xmlGetLastError())
        self.init(document: document)
    }
    
    
    private init(document: xmlDocPtr) {
        _xmlDocument = document
        _rootElement = element(node: xmlDocGetRootElement(_xmlDocument))!
    }
    
    deinit {
        xmlFreeDoc(_xmlDocument)
    }
}

extension XMLDocument: Equatable {}

public func ==(lhs: XMLDocument, rhs: XMLDocument) -> Bool {
    return lhs._xmlDocument == rhs._xmlDocument
}

public extension XMLDocument {
    
    static func HTMLDocument(string string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) throws -> Self {
        return try HTMLDocument(data: string.dataUsingEncoding(encoding))
    }
    static func HTMLDocument(data data: NSData?) throws -> Self {
        let buffer = data.map { UnsafePointer<Int8>($0.bytes) } ?? nil
        let size = Int32(data?.length ?? 0)
        let document = htmlReadMemory(buffer, size, "", nil, Int32(HTML_PARSE_NOWARNING.rawValue | HTML_PARSE_NOERROR.rawValue | HTML_PARSE_RECOVER.rawValue))
        if empty(document) {
            throw NataError.libxmlGetLastError()
        }
        xmlResetError(xmlGetLastError())
        return self.init(document: document)
    }
}

public extension XMLDocument {
    
    func definePrefix(prefix: String, forDefaultNamespace ns: String) {
        defaultNamespaces[ns] = prefix
    }
    
    func enumerateElements(XPath path: String, @noescape usingBlock block: (XMLElement, Int, inout Bool) -> Void) {
        rootElement.enumerateElements(XPath: path, usingBlock: block)
    }
    
    func firstChild(XPath path: String) -> XMLElement? {
        return rootElement.firstChild(XPath: path)
    }
    
    func XPath(path: String) -> AnySequence<XMLElement> {
        return rootElement.XPath(path)
    }
    
    func CSS(css: String) -> AnySequence<XMLElement> {
        return rootElement.CSS(css)
    }
}

extension XMLDocument {
    
    func element(node node: xmlNodePtr) -> XMLElement? {
        if empty(node) {
            return nil
        }
        
        let element = XMLElement(node: node, document: self)
        
        return element
    }
    
    func enumeratorWithXPathObject(XPath: xmlXPathObjectPtr) -> XPathEnumerator? {
        if empty(XPath) || xmlXPathNodeSetIsEmpty(XPath.memory.nodesetval) {
            return nil
        }
        return XPathEnumerator(XPath: XPath, document: self)
    }
}


