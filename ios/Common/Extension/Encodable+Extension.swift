//
//  Encodable+Extension.swift
//  ReactNativeStudy
//
//  Created by Andy Liu on 2020/3/14.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

extension Encodable {
    var dict : [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
}
