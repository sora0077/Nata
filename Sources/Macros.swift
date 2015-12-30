//
//  Macros.swift
//  Nata
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation
import Clibxml2

func xmlXPathNodeSetGetLength(ns: xmlNodeSetPtr) -> Int {
    return exist(ns) ? Int(ns.memory.nodeNr) : 0
}

func xmlXPathNodeSetIsEmpty(ns: xmlNodeSetPtr) -> Bool {
    return empty(ns) || empty(ns.memory.nodeNr) || empty(ns.memory.nodeTab)
}