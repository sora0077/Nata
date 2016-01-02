//
//  XPathFromCSS.swift
//  Nata
//
//  Created by 林達也 on 2015/12/31.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation

private struct CSSRegex {
    static let id = try! NSRegularExpression(pattern: "\\#([\\w-_]+)", options: [])
    
    static let `class` = try! NSRegularExpression(pattern: "\\.([^\\.]+)", options: [])
    
    static let attribute = try! NSRegularExpression(pattern: "\\[(\\w+)\\]", options: [])
}

internal func XPathFromCSS(CSS: String) -> String {
    var XPathExpressions: [String] = []
    for expression in CSS.componentsSeparatedByString(",") {
        guard expression.characters.count > 0 else { continue }
        
        
        var XPathComponents: [String] = ["./"]
        var prefix: String? = nil
        
        for (idx, token) in expression.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            .componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            .enumerate()
        {
            var token = token
            switch token {
            case "*" where idx != 0:
                XPathComponents.append("/*")
            case ">":
                prefix = ""
            case "+":
                prefix = "following-sibling::*[1]/self::"
            case "~":
                prefix = "following-sibling::"
            default:
                if empty(prefix) && idx != 0 {
                    prefix = "descendant::"
                }
                
                if let symbolRange = token.rangeOfCharacterFromSet(NSCharacterSet(charactersInString: "#.[]")) {
                    var XPathComponent = token.substringToIndex(symbolRange.startIndex)
                    let range = NSMakeRange(0, token.characters.count)
                    
                    let symbol = symbolRange.startIndex == token.startIndex ? "*" : ""
                    do {
                        if let result = CSSRegex.id.firstMatchInString(token, options: [], range: range) where result.numberOfRanges > 1 {
                            XPathComponent += "\(symbol)[@id = '\(token[result.rangeAtIndex(1)])']"
                        }
                    }
                    do {
                        for result in CSSRegex.`class`.matchesInString(token, options: [], range: range) {
                            if result.numberOfRanges > 1 {
                                XPathComponent += "\(symbol)[contains(concat(' ',normalize-space(@class),' '),' \(token[result.rangeAtIndex(1)]) ')]"
                            }
                        }
                    }
                    do {
                        for result in CSSRegex.attribute.matchesInString(token, options: [], range: range) {
                            if result.numberOfRanges > 1 {
                                XPathComponent += "[@\(token[result.rangeAtIndex(1)])]"
                            }
                        }
                    }
                    token = XPathComponent
                }
                if let prefix = prefix {
                    token = prefix + token
                }
                prefix = nil
                XPathComponents.append(token)
            }
        }
        XPathExpressions.append(XPathComponents.joinWithSeparator("/"))
    }
    return XPathExpressions.joinWithSeparator(" | ")
}