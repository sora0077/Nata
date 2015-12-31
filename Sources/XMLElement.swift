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

public final class XMLElement {
    
    public internal(set) weak var document: XMLDocument?
    
    public private(set) lazy var namespace: String? = lazy {
        if exist(self.xmlNode.memory.ns) && exist(self.xmlNode.memory.ns.memory.prefix) {
            return String.fromCString(self.xmlNode.memory.ns.memory.prefix)
        }
        return nil
    }
    
    public private(set) lazy var tag: String? = lazy {
        if exist(self.xmlNode.memory.name) {
            return String.fromCString(self.xmlNode.memory.name)
        }
        return nil
    }
    
    public private(set) lazy var lineNumber: Int = lazy {
        return xmlGetLineNo(self.xmlNode)
    }
    
    public private(set) lazy var attributes: [String: String] = lazy {
        var attributes: [String: String] = [:]
        var attribute = self.xmlNode.memory.properties
        while exist(attribute) {
            if let key = String.fromCString(attribute.memory.name) {
                attributes[key] = self.valueForAttribute(key)
            }
            attribute = attribute.memory.next
        }
        return attributes
    }
    
    public var isBlank: Bool {
        return stringValue.isEmpty
    }
    
    public private(set) lazy var stringValue: String = lazy {
        let key = xmlNodeGetContent(self.xmlNode)
        let val = exist(key) ? String.fromCString(key) ?? "" : ""
        xmlFree(key)
        
        return val
    }
    
    public private(set) lazy var dateValue: NSDate? = lazy {
        return self.document?.dateFormatter.dateFromString(self.stringValue)
    }
    
    var xmlNode: xmlNodePtr = nil
}

public extension XMLElement {

    func firstChild(tag tag: String, inNamespace namespace: String? = nil) -> XMLElement? {
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
    
    func children(tag tag: String, inNamespace namespace: String? = nil) -> [XMLElement] {
        guard let indexes = indexesOfChildrenPassingTest({ node, stop in
            XMLNodeMatchesTagInNamespace(node, tag: tag, ns: namespace)
        }) else {
            return []
        }
        let children = childrenAtIndexes(indexes)
        if empty(children.count) {
            return []
        }
        return children
    }
    
}

public extension XMLElement {
    
    func firstChild(XPath path: String) -> XMLElement? {
        
        for element in XPath(path) {
            return element
        }
        return nil
    }
    
    func XPath(path: String) -> AnySequence<XMLElement> {
        
        return AnySequence { _ -> AnyGenerator<XMLElement> in
            let xmlPath = self.xmlXPathObjectPtrWithXPath(path)
            let enumerator: XPathEnumerator?
            if let document = self.document where exist(xmlPath) {
                enumerator =  document.enumeratorWithXPathObject(xmlPath)
            } else {
                enumerator = nil
            }
            return anyGenerator { _ -> XMLElement? in
                if let enumerator = enumerator {
                    return enumerator.nextObject() as? XMLElement
                } else {
                    return nil
                }
            }
        }
        
    }
    
    func functionResultByEvaluatingXPath(path: String) -> XPathFunctionResult? {
        let xmlXPath = xmlXPathObjectPtrWithXPath(path)
        if exist(xmlXPath) {
            let result = XPathFunctionResult(XPath: xmlXPath)
            return result
        }
        return nil
    }
}

public extension XMLElement {
    
}

public extension XMLElement {
    
    func valueForAttribute(attribute: String) -> String? {
        let xmlValue = xmlGetProp(xmlNode, attribute)
        if exist(xmlValue) {
            let value = String.fromCString(xmlValue)
            xmlFree(xmlValue)
            return value
        }
        return nil
    }
}

public extension XMLElement {
    
    func enumerateElements(XPath path: String, @noescape usingBlock block: (XMLElement, Int, inout Bool) -> Void) {
        var idx = 0
        var stop = false
        for element in XPath(path) {
            block(element, idx, &stop)
            idx += 1
            if stop {
                break
            }
        }
    }
}

public extension XMLElement {
    
    subscript (key: String) -> String? {
        return valueForAttribute(key)
    }
}

private extension XMLElement {
    
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

private extension XMLElement {
    
    func xmlXPathObjectPtrWithXPath(path: String) -> xmlXPathObjectPtr {
        let context = xmlXPathNewContext(xmlNode.memory.doc)
        if exist(context) {
            defer {
                xmlXPathFreeContext(context)
            }
            context.memory.node = xmlNode
            
            // Due to a bug in libxml2, namespaces may not appear in `xmlNode->ns`.
            // As a workaround, `xmlNode->nsDef` is recursed to explicitly register namespaces.
            var node = xmlNode
            while exist(node) && exist(node.memory.parent) {
                var ns = node.memory.nsDef
                while exist(ns) {
                    func nsprefix() -> String? {
                        let prefix = ns.memory.prefix
                        if empty(prefix) && document?.defaultNamespaces.count > 0 {
                            if let href = String.fromCString(ns.memory.href) {
                                if let defaultPrefix = document?.defaultNamespaces[href] {
                                    return defaultPrefix
                                }
                            }
                        }
                        return String.fromCString(prefix)
                    }
                    if let prefix = nsprefix() {
                        xmlXPathRegisterNs(context, prefix, ns.memory.href)
                    }
                    ns = ns.memory.next
                }
                node = node.memory.parent
            }
            return xmlXPathEvalExpression(path, context)
        }
        return nil
    }
}

private func XMLNodeMatchesTagInNamespace(node: xmlNodePtr, tag: String?, ns: String?) -> Bool {
    
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
