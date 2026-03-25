//
//  String+Extension.swift
//  DemoSignup
//
//  Created by savan soni on 24/03/26.
//

import Foundation

extension String {
    var appLocalized: String { LocalizationManager.shared.localizedString(for: self) }
    
    var localized: String {
        let result = NSLocalizedString(self, comment: "")
        if result == self {
            print("Localization Missing for Key: \(self)")
        }
        return result
    }
    
    func appLocalized(with arguments: CVarArg...) -> String {
            return withVaList(arguments) { vaList in
                return NSString(format: self.appLocalized, locale: nil, arguments: vaList) as String
            }
        }
}
