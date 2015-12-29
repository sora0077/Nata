//
//  XMLDocument.swift
//  Nata
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation
import Clibxml2

public class XMLDocument {
    
    public var version: String {
        if empty(_version) && exist(_xmlDocument.memory.version) {
            _version = String.fromCString(UnsafePointer<CChar>(_xmlDocument.memory.version))
        }
        return _version
    }
    private var _version: String!
    
    public var stringEncoding: NSStringEncoding {
        if empty(_stringEncoding) && exist(_xmlDocument.memory.encoding) {
            let encodingName = String.fromCString(UnsafePointer<CChar>(_xmlDocument.memory.encoding))
            let encoding = CFStringConvertIANACharSetNameToEncoding(encodingName)
            if encoding != kCFStringEncodingInvalidId {
                _stringEncoding = CFStringConvertEncodingToNSStringEncoding(encoding)
            }
        }
        return _stringEncoding
    }
    private var _stringEncoding: NSStringEncoding = 0
    
//    public private(set) var numberFormatter: NSNumberFormatter
//    
//    public private(set) var dateFormatter: NSDateFormatter
    
    public private(set) var rootElement: XMLElement?
    
    public convenience init(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        try self.init(data: string.dataUsingEncoding(encoding) ?? NSData())
    }
    
    public convenience init(data: NSData) throws {
        let document = xmlReadMemory(UnsafePointer(data.bytes), Int32(data.length), "", nil, Int32(XML_PARSE_NOWARNING.rawValue | XML_PARSE_NOERROR.rawValue | XML_PARSE_RECOVER.rawValue))
        if document == nil {
            try ErrorFromXMLErrorPtr(xmlGetLastError())
        }
        self.init(document: document)
    }
    
    private let _xmlDocument: xmlDocPtr
    private init(document: xmlDocPtr) {
        _xmlDocument = document
//        print(_xmlDocument.memory.name)
        if exist(_xmlDocument) {
            rootElement = element(node: xmlDocGetRootElement(_xmlDocument))
        }
    }
    
    deinit {
        xmlFreeDoc(_xmlDocument)
    }
    
    
    func element(node node: xmlNodePtr) -> XMLElement? {
        if empty(node) {
            return nil
        }
        
        let element = XMLElement()
        element.xmlNode = node
        element.document = self
        
        return element
    }
}
