//
//  UIView+Extension.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import UIKit

@IBDesignable
extension UIView {
    
    // MARK: - Find First Responder
    func findFirstResponder() -> UIView? {
        if self.isFirstResponder { return self }
        for subview in subviews {
            if let responder = subview.findFirstResponder() {
                return responder
            }
        }
        return nil
    }
    
    // MARK: - Corner Radius
    @IBInspectable var cornerRadius: CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    // MARK: - Border Width
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // MARK: - Border Color
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let cgColor = layer.borderColor else { return nil }
            return UIColor(cgColor: cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get { layer.shadowColor.map { UIColor(cgColor: $0) } }
        set { layer.shadowColor = newValue?.cgColor }
    }

    @IBInspectable var shadowOpacity: Float {
        get { layer.shadowOpacity }
        set { layer.shadowOpacity = newValue }
    }

    @IBInspectable var shadowOffset: CGSize {
        get { layer.shadowOffset }
        set { layer.shadowOffset = newValue }
    }

    @IBInspectable var shadowRadius: CGFloat {
        get { layer.shadowRadius }
        set { layer.shadowRadius = newValue }
    }
}
