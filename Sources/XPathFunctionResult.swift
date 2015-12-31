//
//  XPathFunctionResult.swift
//  Nata
//
//  Created by 林達也 on 2015/12/31.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation
import Clibxml2

public final class XPathFunctionResult {
    
    public private(set) lazy var boolValue: Bool = lazy {
        return self._xmlXPath.memory.boolval > 0 ? true : false
    }
    
    public private(set) lazy var numericValue: Double = lazy {
        return self._xmlXPath.memory.floatval
    }
    
    public private(set) lazy var stringValue: String? = lazy {
        return String.fromCString(self._xmlXPath.memory.stringval)
    }
    
    private let _xmlXPath: xmlXPathObjectPtr
    
    init(XPath: xmlXPathObjectPtr) {
        _xmlXPath = XPath
    }
    
    deinit {
        if exist(_xmlXPath) {
            xmlXPathFreeObject(_xmlXPath)
        }
    }
}
