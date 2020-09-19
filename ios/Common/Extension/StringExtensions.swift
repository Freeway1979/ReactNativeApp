//
//  StringExtensions.swift
//  ReactNativeStudy
//
//  Created by Andy Liu on 2020/4/3.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

extension String {

    func toDictionary() -> Parameters? {
        return convertToDictionary()
    }

    func convertToDictionary() -> Parameters? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Parameters
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    func toDictionaryArray() -> [Parameters]? {
        return convertToDictionaryArray()
    }

    func convertToDictionaryArray() -> [Parameters]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Parameters]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }

    // Convert a ClassName String to AnyClass
    func toAnyClass() -> AnyClass? {
        if let appName = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String {
            let validAppName = appName.replacingOccurrences(of: " ", with: "_")
            let fullClassName = "\(validAppName).\(self)"
            let clz: AnyClass? = NSClassFromString(fullClassName)
            return clz
        }
        // return AnyClass!
        return nil
    }

    // Check a string matches a regular expression
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}

extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    // swiftlint:disable identifier_name
    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with range: Range<Int>) -> String {
        let startIndex = index(from: range.lowerBound)
        let endIndex = index(from: range.upperBound)
        return String(self[startIndex..<endIndex])
    }
}
