//
//  JSLogger.swift
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol JSLoggerExports: JSExport {
    func log(_ message: String)
    static func logger(_ tag: String) -> JSLogger
}

/// JS Logger
/// example:
/// var logger = JSLogger.logger('hostname');
/// logger.log('invalid mac');

@objc class JSLogger: NSObject, JSLoggerExports {
    func log(_ message: String) {
        print("JSLogger:\(tag):\(message)")
    }

    public required init(tag: String) {
        self.tag = tag
    }

    static func logger(_ tag: String) -> JSLogger {
        return JSLogger(tag: tag)
    }
    var tag: String
}
