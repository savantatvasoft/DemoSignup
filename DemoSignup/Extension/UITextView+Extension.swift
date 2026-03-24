//
//  UITextView+Extension.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import Foundation
import UIKit

extension UITextView {

    func applySignupDescription(
        fullText: String,
        highlightedText: String,
        link: String
    ) {
        let attributedString = NSMutableAttributedString(string: fullText)
        let fullRange = NSRange(location: 0, length: fullText.count)
        attributedString.addAttributes([
            .foregroundColor: UIColor.darkGray,
            .font: UIFont(name: "Avenir Next", size: 14) ?? UIFont.systemFont(ofSize: 14)
        ], range: fullRange)
        let highlightRange = (fullText as NSString).range(of: highlightedText)

        attributedString.addAttributes([
            .link: link,
            .foregroundColor: UIColor(named: "ActiveText")!,
            .font: UIFont(name: "Avenir Next Bold", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        ], range: highlightRange)

        self.attributedText = attributedString
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.linkTextAttributes = [
            .foregroundColor: UIColor(named: "ActiveText")!,
            .underlineStyle: 0
        ]

        self.isEditable = false
        self.isScrollEnabled = false
        self.isUserInteractionEnabled = true
        self.backgroundColor = .clear
    }
}
