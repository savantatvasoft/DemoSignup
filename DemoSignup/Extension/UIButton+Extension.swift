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
}
