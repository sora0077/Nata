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


func ErrorFromXMLErrorPtr(errorPtr: xmlErrorPtr) throws {
    if errorPtr != nil {
        let message = String.fromCString(errorPtr.memory.message) ?? ""
        let code = errorPtr.memory.code
        
        let userInfo = [
            NSLocalizedFailureReasonErrorKey: message
        ]
        let nsError = NSError(domain: ErrorDomain, code: Int(code), userInfo: userInfo)
        xmlResetError(errorPtr)
        
        throw nsError
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

