//
//  ViewController.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import UIKit
import Combine

class SignupVC: UIViewController {
    
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var languageDropdown: DropdownTableView!
    @IBOutlet weak var scrollView: UIScrollView!
    private var keyboardManager: KeyboardManager!
    @IBOutlet weak var signupDescriptionView: UITextView!
    @IBOutlet weak var inputFieldStackView: UIStackView!
    @IBOutlet weak var collegeOption: RadioOptionView!
    @IBOutlet weak var mosuqueOption: RadioOptionView!
    @IBOutlet weak var mosqueName: InputTextView!
    @IBOutlet weak var mosqueAddress: InputTextView!
    @IBOutlet weak var firstName: InputTextView!
    @IBOutlet weak var lastName: InputTextView!
    @IBOutlet weak var email: InputTextView!
    @IBOutlet weak var password: InputTextView!
    @IBOutlet weak var confirmPassword: InputTextView!
    @IBOutlet weak var mobilePassword: InputTextView!
    @IBOutlet weak var registerButton: UIButton!
    
    var cancellables = Set<AnyCancellable>()
    let viewModel = SignupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardManager = KeyboardManager(scrollView: scrollView, viewController: self)
        setup()
        binding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager.observeKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.stopObserving()
    }
    
    func binding() {
        mosuqueOption.onTap = { [weak self] in
            self?.selectOption(self?.mosuqueOption)
        }
        
        collegeOption.onTap = { [weak self] in
            self?.selectOption(self?.collegeOption)
        }
    }
    
    func selectOption(_ selected: RadioOptionView?) {
        mosuqueOption.isSelectedOption = false
        collegeOption.isSelectedOption = false
        selected?.isSelectedOption = true
    }
    
    
    @IBAction func onPressRegister(_ sender: Any) {
        let fields: [(SignupField, InputTextView)] = [
            (.mosqueName, mosqueName),
            (.mosqueAddress, mosqueAddress),
            (.firstName, firstName),
            (.lastName, lastName),
            (.email, email),
            (.password, password),
            (.confirmPassword, confirmPassword),
            (.mobile, mobilePassword)
        ]
        
        for (field, inputView) in fields {
            viewModel.setValue(for: field, value: inputView.textField.text ?? "")
            inputView.clearError()
        }
        
        viewModel.bindInputViews(Dictionary(uniqueKeysWithValues: fields))
        if viewModel.validate() {
            print("All fields valid, proceed to register")
        } else {
            print("Validation failed")
        }
    }
}

extension SignupVC {
    
    func setup(){
        
        languageDropdown.layer.borderWidth = 1
        languageDropdown.layer.cornerRadius = 8
        languageDropdown.clipsToBounds = true
        
        let currentCode = LocalizationManager.shared.getCurrentLanguageCode()
            let currentDisplayName: String
            switch currentCode {
            case "hi": currentDisplayName = "HIN"
            case "es": currentDisplayName = "SPA"
            default:   currentDisplayName = "ENG"
            }

            // 2. Set the items and the current selection
            languageDropdown.items = ["ENG", "HIN", "SPA"]
            languageDropdown.selectedItem = currentDisplayName // This ensures it shows the correct value on start

            languageDropdown.onSelect = { [weak self] selected in
                let code: String
                switch selected {
                case "HIN": code = "hi"
                case "SPA": code = "es"
                default:   code = "en"
                }
                
                // This triggers the restart/refresh logic
                LocalizationManager.shared.setLanguage(code)
            }
        
        password.setSecure(true)
        confirmPassword.setSecure(true)
        mobilePassword.setSecure(true)
        
        password.setContentType(.password)
        confirmPassword.setContentType(.password)
        
        email.setKeyboard(type: .emailAddress)
        email.setContentType(.emailAddress)
        email.textField.autocapitalizationType = .none
        
        mobilePassword.setKeyboard(type: .numberPad)
        mobilePassword.setContentType(.telephoneNumber)
        mosqueAddress.rightImageView.isHidden = false
        mosqueAddress.rightImageView?.image = UIImage(named: "Pin")
        
        registerButton.applyLanguageStyle(
            title: "Register",
            backgroundColor: UIColor(named: "button")!,
            textColor: .white,
        )
        mosuqueOption.configure(title: "Mosque", isSelected: false)
        collegeOption.configure(title: "College/University", isSelected: false)
        handleLanguage()
    }
    
    private func handleLanguage() {
        signupLabel.text = "signup_title".localized
        registerButton.setTitle("register_btn".localized, for: .normal)
        
        let baseText = "already_account".localized
        let linkText = "login".localized
        
        signupDescriptionView.applySignupDescription(
            fullText: "\(baseText)\(linkText)",
            highlightedText: linkText,
            link: "action://login"
        )
        
        mosuqueOption.configure(title: "radio_mosque".localized, isSelected: mosuqueOption.isSelectedOption)
        collegeOption.configure(title: "radio_college".localized, isSelected: collegeOption.isSelectedOption)
        
        let placeholders = [
            "place_mosque_name".localized,
            "place_mosque_address".localized,
            "place_first_name".localized,
            "place_last_name".localized,
            "place_email".localized,
            "place_password".localized,
            "place_confirm_password".localized,
            "place_mobile_password".localized
        ]
        
        for (index, view) in inputFieldStackView.arrangedSubviews.enumerated() {
            if let inputView = view as? InputTextView, index < placeholders.count {
                inputView.placeholder = placeholders[index]
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension SignupVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == "action://login" {
            print("Login tapped")
            return false
        }
        return true
    }
}


