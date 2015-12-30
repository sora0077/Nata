//
//  XPathEnumerator.swift
//  Nata
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation
import Clibxml2

final class XPathEnumerator: NSEnumerator {
    
    private var _xmlXPath: xmlXPathObjectPtr
    private var _cursor: Int = 0
    private weak var _document: XMLDocument?
    
    init(XPath: xmlXPathObjectPtr, document: XMLDocument?) {
        _xmlXPath = XPath
        _document = document
    }
    
    deinit {
        if exist(_xmlXPath) {
            xmlXPathFreeObject(_xmlXPath)
        }
    }
    
    func objectAtIndex(idx: Int) -> AnyObject? {
        
        if idx >= xmlXPathNodeSetGetLength(_xmlXPath.memory.nodesetval) {
            return nil
        }
        let node = _xmlXPath.memory.nodesetval.memory.nodeTab.advancedBy(idx)
        return _document?.element(node: exist(node) ? node.memory : nil)
    }
    
    override func nextObject() -> AnyObject? {
        
        if _cursor >= Int(_xmlXPath.memory.nodesetval.memory.nodeNr) {
            return nil
        }
        
        let object = objectAtIndex(_cursor)
        _cursor += 1
        return object
    }
}