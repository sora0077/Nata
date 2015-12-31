//
//  Nata.swift
//  Nata
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation
import Clibxml2

private let ErrorDomain = "jp.nata.error"

public enum NataError: ErrorType {
    
    case LibXMLError(code: Int, message: String)
    case ParseError
    
    internal static func libxmlGetLastError(defaults: NataError = .ParseError) -> NataError {
        
        let error = xmlGetLastError()
        if exist(error) {
            let message = String.fromCString(error.memory.message) ?? ""
            let code = error.memory.code
            return .LibXMLError(code: Int(code), message: message)
        }
        return defaults
    }
}

func exist<Wrapped>(w: Optional<Wrapped>) -> Bool {
    return w != nil
}

func exist<Memory>(p: UnsafePointer<Memory>) -> Bool {
    return p != nil
}

func exist<Memory>(p: UnsafeMutablePointer<Memory>) -> Bool {
    return p != nil
}

func empty<I: _IntegerType>(i: I) -> Bool {
    return i == 0
}

func empty<Wrapped>(p: Optional<Wrapped>) -> Bool {
    return !exist(p)
}

func empty<Memory>(p: UnsafePointer<Memory>) -> Bool {
    return !exist(p)
}

func empty<Memory>(p: UnsafeMutablePointer<Memory>) -> Bool {
    return !exist(p)
}

extension String {
    
    static func fromCString(cstr: UnsafePointer<xmlChar>) -> String? {
        return self.fromCString(UnsafePointer<CChar>(cstr))
    }
}
