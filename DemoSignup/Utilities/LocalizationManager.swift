//
//  LocalizationManager.swift
//  DemoSignup
//
//  Created by savan soni on 24/03/26.
//

import UIKit

class LocalizationManager {
    
    static let shared = LocalizationManager()
    private let selectedLanguageKey = "SelectedLanguageCode"
    
    private init() {}
    
    func setLanguage(_ code: String) {
        UserDefaults.standard.set(code, forKey: selectedLanguageKey)
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        resetAppUI()
    }
    
    func getCurrentLanguageCode() -> String {
        return UserDefaults.standard.string(forKey: selectedLanguageKey) ?? "en"
    }
    
    private func resetAppUI() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let rootVC = storyboard.instantiateInitialViewController() {
            window.rootViewController = rootVC
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil,
                              completion: nil)
        }
    }
}
