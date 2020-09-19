//
//  Array+json.swift
//  ReactNativeStudy
//
//  Created by Andy Liu on 2020/3/19.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

extension Array {

    var jsonData: Data? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }
        return jsonData
    }

    var json: String? {
        guard let jsonData = self.jsonData else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}
