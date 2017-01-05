//
//  NotificationRouter.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 2/1/17.
//  Copyright © 2017 Grupo Medios. All rights reserved.
//

import Foundation

enum NotificationRouter:URLRequestConvertible {
    
    var appID : String {
        return CommonConstants.idAppOneSignal()
    }
    
    var appHeader : String {
        return "Basic " + CommonConstants.restAPIKeyOneSignal()
    }
    
    case getAllNotifications(offset: Int)
    
    var method:Method{
        
        switch self {
        case .getAllNotifications(_):
            return .GET
        }
        
    }
    
    var path:String {
        
        switch self {
        case .getAllNotifications(let offset):
            return Endpoints.oneSignalNotification(appID, limit: 50, offset: offset)
        }
        
    }
    
    var URLRequest:NSMutableURLRequest {
        let URL = NSURL(string: path)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL)
        mutableURLRequest.HTTPMethod = method.rawValue
        
        //set custom headers
        Endpoints.setCustomHeaders(mutableURLRequest)
        
        mutableURLRequest.addValue(appHeader, forHTTPHeaderField: "Authorization")
        
        switch self {
        case .getAllNotifications(_):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        }
        
    }
}
