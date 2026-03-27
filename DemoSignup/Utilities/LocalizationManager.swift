//
//  LocalizationManager.swift
//  DemoSignup
//
//  Created by savan soni on 24/03/26.
//


import UIKit

// MARK: - Localization Notification

extension Notification.Name {
    static let languageDidChange = Notification.Name("LanguageDidChange")
}



class LocalizationManager {
    static let shared = LocalizationManager()
    private var bundle: Bundle = .main
   
    var storyboardName: String = "Main"
    var fallbackRootIdentifier: String = "SignupVC"
    
    private init() {
        let code = getCurrentLanguageCode()
        updateBundle(for: code)
    }

    func setLanguage(_ code: String) {
        UserDefaults.standard.set(code, forKey: "SelectedLanguageCode")
        UserDefaults.standard.set([code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        updateBundle(for: code)
        NotificationCenter.default.post(name: .languageDidChange, object: nil)
//        resetAppUI()
    }

    private func updateBundle(for code: String) {
        if let path = Bundle.main.path(forResource: code, ofType: "lproj"),
           let newBundle = Bundle(path: path) {
            self.bundle = newBundle
            print("[LocalizationManager] Using bundle at path: \(path) for code: \(code)")
        } else {
            self.bundle = .main
            print("[LocalizationManager] Falling back to main bundle for code: \(code)")
        }
    }

    func localizedString(for key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }

    func getCurrentLanguageCode() -> String {
        return UserDefaults.standard.string(forKey: "SelectedLanguageCode") ?? "en"
    }

    private func resetAppUI() {
        let activeScenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }

        guard let windowScene = activeScenes.first,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first else {
            return
        }

        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let rootVC = storyboard.instantiateInitialViewController() else {
            let fallback = storyboard.instantiateViewController(withIdentifier: fallbackRootIdentifier)
            window.rootViewController = fallback
            window.makeKeyAndVisible()
            UIView.transition(with: window,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: nil)
            window.layoutIfNeeded()
            return
        }

        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil)
        window.layoutIfNeeded()
    }
}

