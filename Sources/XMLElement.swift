//
//  XMLElement.swift
//  Nata
//
//  Created by 林達也 on 2015/12/30.
//  Copyright © 2015年 jp.sora0077. All rights reserved.
//

import Foundation
import Clibxml2

public class XMLElement {
    
    public internal(set) weak var document: XMLDocument?
    
    public internal(set) var xmlNode: xmlNodePtr = nil
}