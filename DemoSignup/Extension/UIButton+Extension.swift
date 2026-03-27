//
//  UIButton+Extension.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import Foundation
import UIKit


extension UIButton {

    func applyLanguageStyle(
        title: String,
        backgroundColor: UIColor = UIColor(named: "AppYellow")!,
        textColor: UIColor = .black,
        icon: String? = nil
    ) {
        var config = UIButton.Configuration.plain()
        config.title = title

        if let icon = icon {
            config.image = UIImage(systemName: icon)
            config.imagePadding = 4
            config.imagePlacement = .trailing
            config.preferredSymbolConfigurationForImage =
                UIImage.SymbolConfiguration(pointSize: 12)
        }

        config.background.backgroundColor = backgroundColor
        config.baseForegroundColor = textColor
        config.cornerStyle = .capsule

        var attributedTitle = AttributedString(title)
        attributedTitle.font = UIFont(name: UIConfig.fontName, size: 16)

        config.attributedTitle = attributedTitle

        self.configuration = config
    }
    
    func applyCustomStyle(
           title: String,
           backgroundColor: UIColor = .clear,
           textColor: UIColor = .black,
           fontSize: CGFloat = 16,
           iconName: String? = nil,
           alignment: UIControl.ContentHorizontalAlignment = .leading,
           imagePlacement: NSDirectionalRectEdge = .leading,
           cornerStyle: UIButton.Configuration.CornerStyle = .capsule
       ) {
           var config = UIButton.Configuration.plain()
           
           // Title with font
           var attributedTitle = AttributedString(title)
           attributedTitle.font = UIFont(name: UIConfig.fontName, size: fontSize)
           config.attributedTitle = attributedTitle
           
           // Icon
           if let iconName = iconName {
               config.image = UIImage(systemName: iconName)
               config.imagePadding = 6
               config.imagePlacement = imagePlacement
               config.preferredSymbolConfigurationForImage =
                   UIImage.SymbolConfiguration(pointSize: fontSize * 0.85, weight: .medium)
           }
           
           // Colors & Background
           config.background.backgroundColor = backgroundColor
           config.baseForegroundColor = textColor
           config.cornerStyle = cornerStyle
           
           // Alignment (important)
           self.contentHorizontalAlignment = alignment
           
           switch alignment {
           case .leading:
               config.titleAlignment = .leading
           case .trailing:
               config.titleAlignment = .trailing
           case .center:
               config.titleAlignment = .center
           default:
               break
           }
           
           self.configuration = config
       }
}
