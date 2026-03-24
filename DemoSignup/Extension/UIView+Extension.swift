//
//  UIView+Extension.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import Foundation
import UIKit

extension UIView {
    
    func findFirstResponder() -> UIView? {
        if isFirstResponder { return self }
        for subview in subviews {
            if let responder = subview.findFirstResponder() { return responder }
        }
        return nil
    }
}
