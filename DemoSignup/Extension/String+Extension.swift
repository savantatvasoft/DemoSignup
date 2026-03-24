//
//  String+Extension.swift
//  DemoSignup
//
//  Created by savan soni on 24/03/26.
//

import Foundation

extension String {
    
    var localized: String {
        let result = NSLocalizedString(self, comment: "")
        if result == self {
            print("Localization Missing for Key: \(self)")
        }
        return result
    }
    
    func localized(with arguments: CVarArg...) -> String {
            return String(format: self.localized, arguments: arguments)
        }
}
