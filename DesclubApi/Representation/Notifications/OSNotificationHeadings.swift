//
//  OSNotificationHeadings.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 2/1/17.
//  Copyright © 2017 Grupo Medios. All rights reserved.
//

import Foundation

class OSNotificationHeadings: Mappable {
    
    var en: String?
    var es: String?
    
    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {
        en <- map["en"]
        es <- map["es"]
    }
    
    func getText() -> String {
        if let strEn = en {
            return strEn
        }
        
        if let strEs = es {
            return strEs
        }
        
        return ""
    }
    
}
