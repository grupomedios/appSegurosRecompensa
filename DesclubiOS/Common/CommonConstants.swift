//
//  CommonConstants.swift
//  DesclubiOS
//
//  Created by Jhon Cruz on 22/08/15.
//  Copyright (c) 2015 Grupo Medios. All rights reserved.
//

import Foundation

struct CommonConstants {
	
	static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
	static let readableDateFormat = "yyyy-MM-dd"
	
	/**
	Get the app version
	*/
	static func getAppVersion() -> String{
		var appVersion = "0.0"
		if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
			appVersion = version
		}
		
		return appVersion
	}
	
	
	static let baseURL = NSBundle.mainBundle().objectForInfoDictionaryKey("BASE_URL") as! String
	
	//categories
	static let CATEGORY_ALIMENTOS = NSBundle.mainBundle().objectForInfoDictionaryKey("CATEGORY_ALIMENTOS") as! String
	static let CATEGORY_BELLEZA_SALUD = NSBundle.mainBundle().objectForInfoDictionaryKey("CATEGORY_BELLEZA_SALUD") as! String
	static let CATEGORY_EDUCACION = NSBundle.mainBundle().objectForInfoDictionaryKey("CATEGORY_EDUCACION") as! String
	static let CATEGORY_ENTRETENIMIENTO = NSBundle.mainBundle().objectForInfoDictionaryKey("CATEGORY_ENTRETENIMIENTO") as! String
	static let CATEGORY_MODA_HOGAR = NSBundle.mainBundle().objectForInfoDictionaryKey("CATEGORY_MODA_HOGAR") as! String
	static let CATEGORY_SERVICIOS = NSBundle.mainBundle().objectForInfoDictionaryKey("CATEGORY_SERVICIOS") as! String
	static let CATEGORY_TURISMO = NSBundle.mainBundle().objectForInfoDictionaryKey("CATEGORY_TURISMO") as! String
	
	//defaults
	static let DESCLUB_CORPORATE = NSBundle.mainBundle().objectForInfoDictionaryKey("DESCLUB_CORPORATE") as! String
	
	
	//default coordinates
	static let defaultLatitude = 4.6870310366196515
	static let defaultLongitude = -74.0813231640625
	
    static func restAPIKeyOneSignal() -> String {
        return "OTBlY2E4NzYtYjEyZS00MTZiLWI5M2UtZmQyZmY1ZTMxNzk0"
    }
    
    static func idAppOneSignal() -> String {
        return "5a9c9a95-a26f-494f-a9ee-79523842caa4"
    }
}