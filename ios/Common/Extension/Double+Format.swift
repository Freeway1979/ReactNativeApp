//
//  Double+Format.swift
//  ReactNativeStudy
//
//  Created by Andy Liu on 2020/6/30.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

extension Double {
    func format(_ format: String) -> String {
        String(format: format, self)
    }
}
