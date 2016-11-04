//
//  CorporateMembershipFacade.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 14/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

class CorporateMembershipFacade:AbstractFacade {
	
	//singleton pattern for swift
	//check: http://code.martinrue.com/posts/the-singleton-pattern-in-swift
	
	class var sharedInstance: CorporateMembershipFacade {
		struct Static {
			static var instance: CorporateMembershipFacade?
			static var token: dispatch_once_t = 0
		}
		
		dispatch_once(&Static.token) {
			Static.instance = CorporateMembershipFacade()
		}
		
		return Static.instance!
	}
	
	/**
	create a new memberhip
	
	;param: viewController		the viewController
	:param: membership			the membership to be created
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func createCorporateMembreship(viewController:UIViewController, membership:CorporateMembershipInputRepresentation, completionHandler: (CorporateMembershipRepresentation?) -> Void, errorHandler: (ErrorType?, Bool?) -> Void) -> () {
        
        let url = Endpoints.baseURL + Endpoints.corporateMembership()
        let param = Mapper().toJSON(membership)
        
        request(Method.POST, url, parameters: param, encoding: ParameterEncoding.JSON, headers: ["Content-Type": "application/json"]).validate().responseObject { (request, response, membership: CorporateMembershipRepresentation?, raw:AnyObject?, error: ErrorType?) in
            
            if self.isValidResponse(response, viewController: viewController) {
                if error != nil {
                    print(error)
                    if response?.statusCode == 409 {
                        completionHandler(membership)
                    }else{
                        errorHandler(error, nil)
                    }
                }else {
                    completionHandler(membership)
                }
            }else {
                errorHandler(ErrorUtil.createInvalidResponseError(), nil)
            }
        }
        
        
//		request(CorporateMembershipRouter.createCorporateMembership(membership: membership))
//			.validate()
//			.responseObject{ (request, response, membership: CorporateMembershipRepresentation?, raw:AnyObject?, error: ErrorType?) in
//				
//				if self.isValidResponse(response, viewController: viewController) {
//					if error != nil {
//						print(error)
//						if response?.statusCode == 409 {
//							errorHandler(error, true)
//						}else{
//							errorHandler(error, nil)
//						}
//					}else {
//						completionHandler(membership)
//					}
//				}else{
//					errorHandler(ErrorUtil.createInvalidResponseError(), nil)
//				}
//		}
	}
	
	/**
	get corporate membership by number
	
	;param: viewController		the viewController
	:param: number				the membership number
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func getCorporateMembershipByNumber(viewController:UIViewController, number:String, completionHandler: (CorporateMembershipRepresentation?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(CorporateMembershipRouter.getCorporateMembershipByNumber(number: number))
			.validate()
			.responseObject{ (request, response, states: CorporateMembershipRepresentation?, raw:AnyObject?, error: ErrorType?) in
				
				if self.isValidResponse(response, viewController: viewController) {
					if error != nil {
						print(error)
						errorHandler(error)
					}else {
						completionHandler(states)
					}
				}else{
					errorHandler(ErrorUtil.createInvalidResponseError())
				}
		}
		
	}
	
	/**
	get corporate membership by id
	
	;param: viewController		the viewController
	:param: number				the membership number
	:param: completionHandler	the success handler
	:param: errorHandler		the error handler
	*/
	func changeCorporateMembershipStatus(viewController:UIViewController, membershipId:String, corporateMembershipAlreadyUsedRepresentation:CorporateMembershipAlreadyUsedRepresentation, completionHandler: (CorporateMembershipRepresentation?) -> Void, errorHandler: (ErrorType?) -> Void  ) -> () {
		
		request(CorporateMembershipRouter.changeCorporateMembershipStatus(id: membershipId, corporateMembershipAlreadyUsedRepresentation: corporateMembershipAlreadyUsedRepresentation))
			.validate()
			.responseObject{ (request, response, states: CorporateMembershipRepresentation?, raw:AnyObject?, error: ErrorType?) in
				
				if self.isValidResponse(response, viewController: viewController) {
					if error != nil {
						print(error)
						errorHandler(error)
					}else {
						completionHandler(states)
					}
				}else{
					errorHandler(ErrorUtil.createInvalidResponseError())
				}
		}
		
	}
	
}