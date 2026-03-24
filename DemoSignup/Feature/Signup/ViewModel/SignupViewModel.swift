//
//  SignupViewModel.swift
//  DemoSignup
//
//  Created by savan soni on 24/03/26.
//

import Foundation
import Combine
import UIKit

enum SignupField: CaseIterable {
    case mosqueName, mosqueAddress, firstName, lastName
    case email, password, confirmPassword, mobile
}

class SignupViewModel {

    // MARK: - Input
    @Published var mosqueName = ""
    @Published var mosqueAddress = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var mobile = ""

    // MARK: - Output
    @Published var errors: [SignupField: String] = [:]

    // MARK: - Mapping InputTextView for easy updates
    private var inputViewMap: [SignupField: InputTextView] = [:]

    func bindInputViews(_ views: [SignupField: InputTextView]) {
        self.inputViewMap = views
    }

    // MARK: - Validation
    @discardableResult
    func validate() -> Bool {
        var newErrors: [SignupField: String] = [:]

        let fields: [(SignupField, String, String?)] = [
            (.mosqueName, mosqueName, "Mosque Name"),
            (.mosqueAddress, mosqueAddress, "Mosque Address"),
            (.firstName, firstName, "First Name"),
            (.lastName, lastName, "Last Name"),
            (.email, email, "Email"),
            (.password, password, "Password"),
            (.confirmPassword, confirmPassword, "Confirm Password"),
            (.mobile, mobile, "Mobile")
        ]

        for (field, value, name) in fields {
            if value.isEmpty, let name = name {
                newErrors[field] = "\(name) is required"
            }
        }

        if !email.isEmpty && !isValidEmail(email) { newErrors[.email] = "Invalid email" }
        if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
            newErrors[.confirmPassword] = "Passwords do not match"
        }
        if !mobile.isEmpty && !isValidMobile(mobile) { newErrors[.mobile] = "Invalid mobile number" }

        errors = newErrors
        updateInputViewsErrors()
        return newErrors.isEmpty
    }

    // MARK: - Helpers

    private func updateInputViewsErrors() {
        for field in SignupField.allCases {
            if let inputView = inputViewMap[field] {
                inputView.error = errors[field]
            }
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }

    private func isValidMobile(_ mobile: String) -> Bool {
        return !mobile.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}


extension SignupViewModel {
    func setValue(for field: SignupField, value: String) {
        switch field {
        case .mosqueName: mosqueName = value
        case .mosqueAddress: mosqueAddress = value
        case .firstName: firstName = value
        case .lastName: lastName = value
        case .email: email = value
        case .password: password = value
        case .confirmPassword: confirmPassword = value
        case .mobile: mobile = value
        }
    }
}
