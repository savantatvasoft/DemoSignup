//
//  UIImageView+Extension.swift
//  DemoSignup
//
//  Created by savan soni on 26/03/26.
//

import UIKit

@IBDesignable
extension UIImageView {

    // MARK: - Corner Radius
    @IBInspectable var imageCornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true 
        }
    }

    // MARK: - Border Width
    @IBInspectable var imageBorderWidth: CGFloat {
        get { layer.borderWidth }
        set {
            layer.borderWidth = newValue
        }
    }

    // MARK: - Border Color
    @IBInspectable var imageBorderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    // MARK: - Optional: Make Circular
    @IBInspectable var makeCircular: Bool {
        get { return false }
        set {
            if newValue {
                layoutIfNeeded()
                layer.cornerRadius = frame.height / 2
                layer.masksToBounds = true
            }
        }
    }
}
