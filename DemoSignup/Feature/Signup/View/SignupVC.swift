//
//  ViewController.swift
//  DemoSignup
//
//  Created by MACM72 on 23/03/26.
//

import UIKit
import Combine
import GooglePlaces

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
    
    private var suggestions: [GMSAutocompletePrediction] = []
    private let tableView = UITableView()
    var countForRegisterBtnPress:Int = 0
    
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
    
    @IBAction func onPressRegister(_ sender: Any) {
        countForRegisterBtnPress = 1
        pressRegister()
    }
    
    func pressRegister() {
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
        if countForRegisterBtnPress != 0 {
            if viewModel.validate() {
                AppSession.shared.signupVM = self.viewModel
                performSegue(withIdentifier: "naviagteToDashboard", sender: self)
                print("All fields valid, proceed to register")
            } else {
                print("Validation failed")
            }
           
        }
    }
}

extension SignupVC {
    
    func setup(){
        languageDropdown.layer.borderWidth = 1
        languageDropdown.layer.cornerRadius = 8
        languageDropdown.clipsToBounds = true
        
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
        
        mosuqueOption.configure(title: "Mosque", isSelected: false)
        collegeOption.configure(title: "College/University", isSelected: false)
        handleLanguage()
        setupTableViewForShowLocation()
    }
    
    
    func setupTableViewForShowLocation() {
        mosqueAddress.textField.addTarget(self,
                                          action: #selector(onAddressChange),
                                          for: .editingChanged)
        
        mosqueAddress.isUserInteractionEnabled = true
        mosqueAddress.textField.isUserInteractionEnabled = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.backgroundColor = .white
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mosqueAddress.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: mosqueAddress.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mosqueAddress.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func handleLanguage() {
        signupLabel.text = "signup_title".appLocalized
        registerButton.applyLanguageStyle(
            title: "register_btn".appLocalized,
            backgroundColor: UIColor(named: "button")!,
            textColor: .white,
        )
        let baseText = "already_account".appLocalized
        let linkText = "login".appLocalized
        
        signupDescriptionView.applySignupDescription(
            fullText: "\(baseText)\(linkText)",
            highlightedText: linkText,
            link: "action://login"
        )
        
        mosuqueOption.configure(title: "radio_mosque".appLocalized, isSelected: mosuqueOption.isSelectedOption)
        collegeOption.configure(title: "radio_college".appLocalized, isSelected: collegeOption.isSelectedOption)
        
        let placeholders = [
            "place_mosque_name".appLocalized,
            "place_mosque_address".appLocalized,
            "place_first_name".appLocalized,
            "place_last_name".appLocalized,
            "place_email".appLocalized,
            "place_password".appLocalized,
            "place_confirm_password".appLocalized,
            "place_mobile_password".appLocalized
        ]
        
        for (index, view) in inputFieldStackView.arrangedSubviews.enumerated() {
            if let inputView = view as? InputTextView, index < placeholders.count {
                inputView.placeholder = placeholders[index]
            }
        }
        setupLanguageDropdown()
    }
    
    // MARK: - Language Dropdown Setup
    func setupLanguageDropdown() {
        let enShort = "lang_en".appLocalized
        let hiShort = "lang_hi".appLocalized
        let esShort = "lang_es".appLocalized
    
        languageDropdown.items = [enShort, hiShort, esShort]
        let currentCode = LocalizationManager.shared.getCurrentLanguageCode()
        
        switch currentCode {
            case "hi":
                languageDropdown.selectedItem = hiShort
            case "es":
                languageDropdown.selectedItem = esShort
            default:
                languageDropdown.selectedItem = enShort
        }
    }
    
    @objc private func onAddressChange(_ textField: UITextField) {
        viewModel.setValue(for: .mosqueAddress, value: textField.text ?? "")
        viewModel.searchAddress(query: textField.text ?? "")
    }
    
    func binding() {
        
        //MARK: Callbacks
        languageDropdown.onSelect = { [weak self] selected in
            let code: String
            
            if selected == "lang_hi".appLocalized {
                code = "hi"
            } else if selected == "lang_es".appLocalized {
                code = "es"
            } else {
                code = "en"
            }
           
            LocalizationManager.shared.setLanguage(code)
            self?.handleLanguage()
        }
        
        mosuqueOption.onTap = { [weak self] in
            self?.selectOption(self?.mosuqueOption)
        }
        
        collegeOption.onTap = { [weak self] in
            self?.selectOption(self?.collegeOption)
        }
        
        //MARK: Observer - Listener
        viewModel.$addressSuggestions
            .receive(on: RunLoop.main)
            .sink { [weak self] suggestions in
                self?.suggestions = suggestions
                self?.tableView.reloadData()
                self?.tableView.isHidden = suggestions.isEmpty
            }
            .store(in: &cancellables)
        
        viewModel.$mosqueAddress
            .receive(on: RunLoop.main)
            .sink { [weak self] address in
                self?.mosqueAddress.textField.text = address
            }
            .store(in: &cancellables)
        
        //MARK: Events
        
        NotificationCenter.default.publisher(for: .languageDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.pressRegister()
                self?.handleLanguage()
            }
            .store(in: &cancellables)
    }
    
    func selectOption(_ selected: RadioOptionView?) {
        mosuqueOption.isSelectedOption = false
        collegeOption.isSelectedOption = false
        selected?.isSelectedOption = true
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


// MARK: - Show List of Places from Google Palce API
extension SignupVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let item = suggestions[indexPath.row]
        
        cell.textLabel?.text = item.attributedFullText.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = suggestions[indexPath.row]
        viewModel.selectAddress(prediction: selection)
    }
}
