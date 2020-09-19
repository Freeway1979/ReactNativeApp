//
//  DataEvent.swift
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

enum DataEventType: String {
    case onLeftBarButtonClicked
    case onRightBarButtonClicked
    case onCommonDataReturned
    // define more cases
    case onDiaglogTextReturned
}

struct DataEvent {
    var eventType: DataEventType = .onCommonDataReturned
    // To identify sub type, you can define everything you want. and your JS can get it for your purpose.
    var category: String = ""
    var data: Parameters?

    var dict: Parameters {
        return ["eventType": eventType.rawValue,
                "data": data ?? [:]
        ]
    }
    
    init(eventType: DataEventType = .onCommonDataReturned, data: Parameters?, category: String = "") {
        self.eventType = eventType
        self.data = data
        self.category = category
    }
}
