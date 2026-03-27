//
//  SignupViewModel.swift
//  DemoSignup
//
//  Created by savan soni on 24/03/26.
//

import Foundation
import Combine
import UIKit
import GooglePlaces

enum SignupField: CaseIterable {
    case mosqueName, mosqueAddress, firstName, lastName
    case email, password, confirmPassword, mobile
}

class SignupViewModel {
    
    @Published var mosqueName = ""
    @Published var mosqueAddress = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var mobile = ""
    @Published var errors: [SignupField: String] = [:]
    @Published var addressSuggestions: [GMSAutocompletePrediction] = []
    
    private var inputViewMap: [SignupField: InputTextView] = [:]
    
    
    func bindInputViews(_ views: [SignupField: InputTextView]) {
        self.inputViewMap = views
    }
    
    func searchAddress(query: String) {
        if query.isEmpty {
            addressSuggestions = []
            GooglePlacesManager.shared.endSession()
            return
        }
        
        GooglePlacesManager.shared.startSession()
        GooglePlacesManager.shared.fetchPlaces(query: query) { [weak self] results in
            DispatchQueue.main.async {
                self?.addressSuggestions = results
            }
        }
    }
   
    func selectAddress(prediction: GMSAutocompletePrediction) {
        GooglePlacesManager.shared.fetchPlaceDetails(placeID: prediction.placeID) { [weak self] result in
            guard let result = result else { return }
            DispatchQueue.main.async {
                self?.mosqueAddress = result.address
                self?.addressSuggestions = []
            }
        }
    }

    
    @discardableResult
    func validate() -> Bool {
        var newErrors: [SignupField: String] = [:]
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
        
        for (field, value, key) in validationTargets {
            if value.trimmingCharacters(in: .whitespaces).isEmpty {
                let translatedFieldName = key.appLocalized
                newErrors[field] = "err_required".appLocalized(with: translatedFieldName)
            }
        }
        
        // 2. Format Validations
        if !email.isEmpty && !isValidEmail(email) {
            newErrors[.email] = "err_invalid_email".appLocalized
        }
        
        if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
            newErrors[.confirmPassword] = "err_password_mismatch".appLocalized
        }
        
        if !mobile.isEmpty && !isValidMobile(mobile) {
            newErrors[.mobile] = "err_invalid_mobile".appLocalized
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
