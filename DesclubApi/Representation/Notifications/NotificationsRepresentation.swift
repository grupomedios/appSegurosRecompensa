//
//  NotificationsRepresentation.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 2/1/17.
//  Copyright © 2017 Grupo Medios. All rights reserved.
//

import Foundation

class NotificationsRepresentation: Mappable {
    
    var total_count: Int?
    var offset: Int?
    var limit: Int?
    var notifications: [OSNotification]?
    
    required init?(_ map: Map){
        
    }

    func mapping(map: Map) {
        total_count <- map["total_count"]
        offset <- map["offset"]
        limit <- map["limit"]
        notifications <- map["notifications"]
    }
    
    func getArrNotificationsIOS(id: String) -> [OSNotification] {
        
        var arrNotifications = [OSNotification]()
        
        if let arr = self.notifications {
            for obj in arr {
                if let isIos = obj.isIos {
                    if isIos.boolValue {
                        
                        if let players = obj.include_player_ids {
                            if players.count > 0{
                                
                                if players.contains(id) {
                                    // Agregar
                                    arrNotifications.append(obj)
                                }
                                // else -> no agreagar.
                                
                            }else {
                                arrNotifications.append(obj)
                            }
                            
                        }else {
                            arrNotifications.append(obj)
                        }
                        
                    }
                }
            }
        }
        
        return arrNotifications

    }
}
