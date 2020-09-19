//
//  Localize.swift
//  Study
//
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

/// Default language. English. If English is unavailable defaults to base localization.
let localizedDefaultLanguage = "en"

/// Base bundle as fallback.
let baseBundle = "Base"

/// Name for language change notification
public let languageChangeNotification = "LanguageChangeNotification"

extension Notification.Name {
    static let currentLanguageChanged = Notification.Name(rawValue: languageChangeNotification)
}

class Localize {
    class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        if let indexOfBase = availableLanguages.firstIndex(of: "Base"), excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }

    class func currentLanguage() -> String {
        // TODO:
        return "en"
    }

    class func setCurrentLanguage(_ language: String) {
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if selectedLanguage != currentLanguage() {
            // TODO: set language
            NotificationCenter.default.post(name: .currentLanguageChanged, object: nil)
        }
    }

    class func defaultLanguage() -> String {
        var defaultLanguage = String()
        guard let preferredLanguage = Bundle.main.preferredLocalizations.first else {
            return defaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        if availableLanguages.contains(preferredLanguage) {
            defaultLanguage = preferredLanguage
        } else {
            defaultLanguage = localizedDefaultLanguage
        }
        return defaultLanguage
    }

    class func resetCurrentLanguageToDefault() {
        setCurrentLanguage(self.defaultLanguage())
    }
}
