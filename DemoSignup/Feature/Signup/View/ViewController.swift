//
//  ViewController.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import UIKit
import Combine

class ViewController: UIViewController {

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

        let placeholders = [
            "Name of Mosque",
            "Mosque Address",
            "First Name",
            "Last Name",
            "Email ID",
            "Password",
            "Confirm Password",
            "Mobile Password"
        ]

        for (index, view) in inputFieldStackView.arrangedSubviews.enumerated() {
            if let inputView = view as? InputTextView {
                inputView.placeholder = placeholders[index]
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager.observeKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.stopObserving()
    }

    func setup(){

        languageDropdown.layer.borderWidth = 1
        languageDropdown.layer.cornerRadius = 8
        languageDropdown.clipsToBounds = true

        languageDropdown.items = ["Eng", "Hin", "Spa"]
        languageDropdown.onSelect = {  (selected: String) in
                   print("Selected: \(selected)")
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

        setupSignupDescriptionView()
        mosuqueOption.configure(title: "Mosque", isSelected: false)
        collegeOption.configure(title: "College/University", isSelected: false)
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

    private func setupSignupDescriptionView() {
        signupDescriptionView.delegate = self
        signupDescriptionView.applySignupDescription(
            fullText: "Already have an account? Login",
            highlightedText: "Login",
            link: "action://login"
        )
    }

    @IBAction func onPressRegister(_ sender: Any) {

        // Sync UI → ViewModel
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

        // Bind InputViews once (usually in viewDidLoad)
        viewModel.bindInputViews(Dictionary(uniqueKeysWithValues: fields))

        // Validate
        if viewModel.validate() {
            print("✅ All fields valid, proceed to register")
        } else {
            print("❌ Validation failed")
        }
    }
}

// MARK: - UITextViewDelegate

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if URL.absoluteString == "action://login" {
            print("Login tapped")
            return false
        }
        return true
    }
}


