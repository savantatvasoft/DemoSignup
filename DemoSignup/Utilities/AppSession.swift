//
//  AppSession.swift
//  DemoSignup
//
//  Created by savan soni on 26/03/26.
//

import Foundation

class AppSession {
    static let shared = AppSession()
    
    private init() {}
    
    var signupVM: SignupViewModel?
}
