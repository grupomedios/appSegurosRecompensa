//
//  CorporateMembershipRouter.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 14/09/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

enum CorporateMembershipRouter:URLRequestConvertible {
	
	case getCorporateMembershipByNumber(number:String)
	case changeCorporateMembershipStatus(id:String, corporateMembershipAlreadyUsedRepresentation:CorporateMembershipAlreadyUsedRepresentation)
	case createCorporateMembership(membership:CorporateMembershipInputRepresentation)
	
	var method:Method{
		
		switch self {
		case .getCorporateMembershipByNumber:
			return .GET
		case .changeCorporateMembershipStatus:
			return .PUT
		case .createCorporateMembership:
			return .POST
		}
		
	}
	
	var path:String {
		
		switch self {
		case .getCorporateMembershipByNumber(let number):
			return Endpoints.corporateMembershipsByNumber(number)
		case .changeCorporateMembershipStatus(let params):
			return Endpoints.corporateMembershipsById(params.id)
		case .createCorporateMembership:
			return Endpoints.corporateMembership()
		}
		
	}
	
	var URLRequest:NSMutableURLRequest {
		let URL = NSURL(string: Endpoints.baseURL)!
		let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
		mutableURLRequest.HTTPMethod = method.rawValue
        
		//set custom headers
		Endpoints.setCustomHeaders(mutableURLRequest)
		
		switch self {
			
		case .changeCorporateMembershipStatus(let params):
			return ParameterEncoding.JSON.encode(mutableURLRequest, parameters: Mapper().toJSON(params.corporateMembershipAlreadyUsedRepresentation)).0
			
		case .createCorporateMembership(let params):
			return ParameterEncoding.JSON.encode(mutableURLRequest, parameters: Mapper().toJSON(params)).0
			
		default:
			return mutableURLRequest
			
		}
		
	}
	
}