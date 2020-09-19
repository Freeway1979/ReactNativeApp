//
//  NSRegularExpressionExtensions.swift
//  ReactNativeStudy
//
//  Created by Andy Liu on 2020/4/17.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

extension NSRegularExpression {
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf8.count)
        let result = firstMatch(in: string, options: [], range: range) != nil
        return result
    }
}
