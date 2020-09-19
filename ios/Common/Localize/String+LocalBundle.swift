//
//  String+LocalBundle.swift
//  Study
//
//  Created by Andy Liu on 2020/8/17.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

func localized(_ string: String) -> String {
    return string.localized()
}

extension String {
    func localized() -> String {
        return localized(using: nil, in: nil)
    }

    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }

    func localized(in bundle: Bundle?) -> String {
        return localized(using: nil, in: bundle)
    }

    func localizedFormat(arguments: CVarArg..., in bundle: Bundle?) -> String {
        return String(format: localized(in: bundle), arguments: arguments)
    }

    func localized(using tableName: String?) -> String {
        return localized(using: tableName, in: nil)
    }

    func localizedFormat(arguments: CVarArg..., using tableName: String?) -> String {
        return String(format: localized(using: tableName), arguments: arguments)
    }

    func localized(using tableName: String?, in bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        } else if let path = bundle.path(forResource: baseBundle, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }

    func localizedFormat(arguments: CVarArg..., using tableName: String?, in bundle: Bundle?) -> String {
        return String(format: localized(using: tableName, in: bundle), arguments: arguments)
    }
}
