//
//  DashboardVM.swift
//  DemoSignup
//
//  Created by savan soni on 26/03/26.
//

import Foundation


class DashboardVM {
    
    private var signupVM: SignupViewModel?
    
    init() {
        self.signupVM = AppSession.shared.signupVM
        print("AppSession.shared.signupVM \(AppSession.shared.signupVM)")
    }
    
    var userName: String {
        return signupVM?.firstName ?? "N/A"
    }
    
    var userAddress: String {
        return signupVM?.mosqueAddress ?? "N/A"
    }
}
