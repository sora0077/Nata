//
//  XMLElement.swift
//  Nata
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation
import Clibxml2

func lazy<T>(@noescape f: () -> T) -> T {
    return f()
}

public class XMLElement {
    
    public internal(set) weak var document: XMLDocument?
    
    public lazy var tag: String? = lazy {
        if exist(self.xmlNode.memory.name) {
            return String.fromCString(self.xmlNode.memory.name)
        }
        return nil
    }
    
    public lazy var stringValue: String = lazy {
        let key = xmlNodeGetContent(self.xmlNode)
        let val = exist(key) ? String.fromCString(key) ?? "" : ""
        xmlFree(key)
        
        return val
    }
    
    var xmlNode: xmlNodePtr = nil
    
    public func firstChild(tag tag: String, inNamespace namespace: String? = nil) -> XMLElement? {
        guard let indexes = indexesOfChildrenPassingTest({ node, stop in
            stop = XMLNodeMatchesTagInNamespace(node, tag: tag, ns: namespace)
            return stop
        }) else {
            return nil
        }
        let children = childrenAtIndexes(indexes)
        if empty(children.count) {
            return nil
        }
        return children[0]
    }
    
    func childrenAtIndexes(indexes: NSIndexSet) -> [XMLElement] {
        
        guard let doc = document else {
            return []
        }
        
        var children: [XMLElement] = []
        
        var cursor = xmlNode.memory.children
        var idx: Int = 0
        while exist(cursor) {
            if indexes.contains(idx) && cursor.memory.type == XML_ELEMENT_NODE {
                if let elem = doc.element(node: cursor) {
                    children.append(elem)
                }
            }
            
            cursor = cursor.memory.next
            idx += 1
        }
        return children
    }
    
    func indexesOfChildrenPassingTest(test: (xmlNodePtr, inout Bool) -> Bool) -> NSIndexSet? {
        let mutableIndexSet = NSMutableIndexSet()
        
        var cursor = xmlNode.memory.children
        var idx: Int = 0
        var stop: Bool = false
        while exist(cursor) && !stop {
            if test(cursor, &stop) {
                mutableIndexSet.addIndex(idx)
            }
            
            cursor = cursor.memory.next
            idx += 1
        }
        
        return mutableIndexSet
    }
}

func XMLNodeMatchesTagInNamespace(node: xmlNodePtr, tag: String?, ns: String?) -> Bool {
    
    let matchingTag: Bool
    if let tag = tag {
        matchingTag = String.fromCString(node.memory.name)?.compare(tag, options: .CaseInsensitiveSearch) == .OrderedSame
    } else {
        matchingTag = true
    }
    
    let matchingNamespace: Bool
    if let ns = ns {
        if exist(node.memory.ns) && exist(node.memory.ns.memory.prefix) {
            matchingNamespace = String.fromCString(node.memory.ns.memory.prefix)?.compare(ns, options: .CaseInsensitiveSearch) == .OrderedSame
        } else {
            matchingNamespace = false
        }
    } else {
        matchingNamespace = true
    }
    
    return matchingTag && matchingNamespace
}
