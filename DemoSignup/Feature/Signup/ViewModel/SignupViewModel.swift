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
    
    
    @discardableResult
    func validate() -> Bool {
        var newErrors: [SignupField: String] = [:]
        
        // We store the KEY and the VALUE.
        // We do NOT localize the name here to avoid errors in the loop.
        let validationTargets: [(SignupField, String, String)] = [
            (.mosqueName, mosqueName, "field_mosque_name"),
            (.mosqueAddress, mosqueAddress, "field_mosque_address"),
            (.firstName, firstName, "field_first_name"),
            (.lastName, lastName, "field_last_name"),
            (.email, email, "field_email"),
            (.password, password, "field_password"),
            (.confirmPassword, confirmPassword, "field_confirm_password"),
            (.mobile, mobile, "field_mobile")
        ]
        
        // 1. Required Field Validation
        for (field, value, key) in validationTargets {
            if value.trimmingCharacters(in: .whitespaces).isEmpty {
                // Get the translated field name (e.g., "First Name")
                let translatedFieldName = key.localized
                
                // Inject it into the "is required" template
                // Result: "First Name is required" or "पहला नाम आवश्यक है"
                newErrors[field] = "err_required".localized(with: translatedFieldName)
            }
        }
        
        // 2. Format Validations
        if !email.isEmpty && !isValidEmail(email) {
            newErrors[.email] = "err_invalid_email".localized
        }
        
        if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
            newErrors[.confirmPassword] = "err_password_mismatch".localized
        }
        
        if !mobile.isEmpty && !isValidMobile(mobile) {
            newErrors[.mobile] = "err_invalid_mobile".localized
        }
        
        self.errors = newErrors
        updateInputViewsErrors()
        return newErrors.isEmpty
    }
    
    private func updateInputViewsErrors() {
        for field in SignupField.allCases {
            inputViewMap[field]?.error = errors[field]
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
