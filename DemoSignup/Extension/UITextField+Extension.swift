//
//  UITextField+Extension.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import Foundation
import UIKit
import Combine

extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }

    func applyPlaceholderStyle() {
        guard let text = self.placeholder else { return }

        let baseFont = UIFont(name: "Avenir Next", size: 16)
            ?? UIFont.systemFont(ofSize: 16)

        let boldFont = baseFont.withTraits(traits: .traitBold)

        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .font: boldFont,
                .foregroundColor: UIColor.black
            ]
        )
    }

    func applyPlaceholderMedium(_ text: String) {
        let font = UIFont(name: UIConfig.fontName, size: 16)
        ?? UIFont.systemFont(ofSize: 16, weight: .semibold)

        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: UIColor(named: "ActiveText")!
            ]
        )
    }
}
