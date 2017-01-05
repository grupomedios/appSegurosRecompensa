//
//  OSNotification.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 2/1/17.
//  Copyright © 2017 Grupo Medios. All rights reserved.
//

import Foundation

class OSNotification: Mappable {
    
    var id: String?
    var successful: Int?
    var failed: Int?
    var converted: Int?
    var remaining: Int?
    var queued_at: NSNumber?
    var send_after: NSNumber?
    var canceled: NSNumber?
    var url: String?
    var data: AnyObject?
    var isIos: NSNumber?
    var include_player_ids: [String]?
    
//    "app_id": "38bae23b-5e0b-49f3-933e-8e01c8ea9f41",
//    "content_available": false,
//    "contents": {
//    "en": "sdadasda"
//    },
//    "converted": 1,
//    "data": null,
//    "delayed_option": "immediate",
//    "delivery_time_of_day": "6:15 PM",
//    "errored": 0,
//    "excluded_segments": [],
//    "failed": 0,
//    "headings": {
//    "en": "Asdadf"
//    },
//    "id": "ddf6f499-9c78-400b-aabe-fb4dd6595b80",
//    "include_player_ids": [
//    "10a407aa-0047-4948-98e2-cad0f77ba005"
//    ],
//    "included_segments": [],
//    "ios_badgeCount": 1,
//    "ios_badgeType": "None",
//    "ios_category": "",
//    "ios_sound": "",
//    "successful": 1,


    var headings: OSNotificationHeadings?
    var contents: OSNotificationContent?

    required init?(_ map: Map){
        
    }
    
    func mapping(map: Map) {

        id <- map["id"]
        successful <- map["successful"]
        failed <- map["failed"]
        converted <- map["converted"]
        remaining <- map["remaining"]
        queued_at <- map["queued_at"]
        send_after <- map["send_after"]
        canceled <- map["canceled"]
        url <- map["url"]
        data <- map["data"]
        
        headings <- map["headings"]
        contents <- map["contents"]

        isIos <- map["isIos"]
        include_player_ids <- map["include_player_ids"]
    }
    
    func getDate() -> String {
        
        if let t = self.queued_at {
            let date = NSDate(timeIntervalSince1970: t.doubleValue)
            
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale.currentLocale()
            formatter.dateFormat = "dd-MM-yyyy"
            
            return formatter.stringFromDate(date)
        }
        
        return ""
    }
    
}
