//
//  Collection+SafeSubscript.swift
//  ReactNativeStudy
//
//  Created by Andy Liu on 2020/5/25.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
