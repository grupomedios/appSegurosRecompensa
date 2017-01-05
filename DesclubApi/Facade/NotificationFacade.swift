//
//  NotificationFacade.swift
//  DesclubiOS
//
//  Created by Sergio Maturano on 4/1/17.
//  Copyright © 2017 Grupo Medios. All rights reserved.
//

import Foundation

class NotificationFacade: AbstractFacade {
    
    static let sharedInstance = NotificationFacade()
    
    func getAllNotificationsWithOffset(viewController:UIViewController, number:Int, completionHandler: (NotificationsRepresentation?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
        
        request(NotificationRouter.getAllNotifications(offset: number))
            .validate()
            .responseObject { (request, response, notifications: NotificationsRepresentation?, raw:AnyObject?, error: ErrorType?) in

                if self.isValidResponse(response, viewController: viewController) {
                    if error != nil {
                        print(error)
                        errorHandler(error)
                    }else {
                        completionHandler(notifications)
                    }
                }else{
                    errorHandler(ErrorUtil.createInvalidResponseError())
                }
        }

    }
}
