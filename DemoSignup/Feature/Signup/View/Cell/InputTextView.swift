//
//  InputTextView.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import Foundation
import UIKit

class InputTextView: UIView {

//    @IBOutlet weak var errorContainer: UIView!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var containerView: UIView!

    @IBOutlet weak var errorText: UILabel!
    
    var placeholder: String? {
        didSet {
            guard let placeholder = placeholder else { return }
            textField.applyPlaceholderMedium(placeholder)
        }
    }
    
    var error: String? {
        didSet {
            let hasError = !(error?.isEmpty ?? true)
            errorText.text = error
            errorText.isHidden = !hasError
            containerView.layer.borderColor = hasError
                ? UIColor.red.cgColor
                : UIColor.systemGray4.cgColor

            DispatchQueue.main.async {
                self.layoutIfNeeded()
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
    }

    private func loadNib() {
        guard let view = Bundle.main.loadNibNamed("InputTextView", owner: self, options: nil)?.first as? UIView else {
            print("XIB not loaded")
            return
        }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)

        setupUI()
    }

    private func setupUI() {
        containerView.layer.cornerRadius = 7
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.systemGray4.cgColor

        textField.font = UIFont(name: UIConfig.fontName, size: 16)
        ?? UIFont.systemFont(ofSize: 16)

        rightImageView.contentMode = .scaleAspectFit
        rightImageView.isHidden = true
        
        errorText.isHidden = true
        /*errorText.text = ""*/
    }

    func configure(
        placeholder: String,
        image: UIImage?
    ) {
        self.placeholder = placeholder
        rightImageView.image = image
        rightImageView.isHidden = (image == nil)
    }
}

extension InputTextView {

    func setSecure(_ isSecure: Bool) {
        textField.isSecureTextEntry = isSecure
    }

    func setKeyboard(type: UIKeyboardType) {
        textField.keyboardType = type
    }

    func setContentType(_ type: UITextContentType) {
        textField.textContentType = type
    }
    
    func clearError() {
        self.error = nil
    }
}
