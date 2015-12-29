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
    
//    public private(set) var numberFormatter: NSNumberFormatter
//    
//    public private(set) var dateFormatter: NSDateFormatter
    
    public private(set) var rootElement: XMLElement?
    
    public convenience init(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding) throws {
        try self.init(data: string.dataUsingEncoding(encoding) ?? NSData())
    }
    
    public convenience init(data: NSData) throws {
        let document = xmlReadMemory(UnsafePointer(data.bytes), Int32(data.length), "", nil, Int32(XML_PARSE_NOWARNING.rawValue | XML_PARSE_NOERROR.rawValue | XML_PARSE_RECOVER.rawValue))
        if empty(document) {
            try ErrorFromXMLErrorPtr(xmlGetLastError())
        }
        self.init(document: document)
    }
    
    private let _xmlDocument: xmlDocPtr
    private init(document: xmlDocPtr) {
        _xmlDocument = document
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
