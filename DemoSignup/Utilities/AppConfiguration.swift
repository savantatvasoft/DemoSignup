//
//  AppConfiguration.swift
//  DemoSignup
//
//  Created by savan soni on 25/03/26.
//

import Foundation

enum AppConfig {
    static var googlePlacesAPIKey: String {
        
        guard let key = Bundle.main.object(forInfoDictionaryKey: "GooglePlacesAPIKey") as? String else {
            fatalError("GooglePlacesAPIKey not found in Info.plist")
        }
        return key
    }
}
