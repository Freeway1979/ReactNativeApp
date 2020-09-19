//
//  MixerReactModule.swift
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation

class MixerReactModule: NSObject {

    static let shared = MixerReactModule()

    var bridge: RCTBridge?

    func createBridgeIfNeeded() -> RCTBridge {
        if bridge == nil {
            bridge = RCTBridge(delegate: self, launchOptions: nil)
        }
        return bridge!
    }

    func viewForModule(_ moduleName: String, initProps: [String: Any]?) -> RCTRootView {
        let viewBridge = createBridgeIfNeeded()
        let rootView = RCTRootView(bridge: viewBridge,
                                   moduleName: moduleName,
                                   initialProperties: initProps)
        return rootView
    }

}

extension MixerReactModule: RCTBridgeDelegate {
    func sourceURL(for bridge: RCTBridge!) -> URL! {
        #if DEBUG
        print("running in debug mode")
        return RCTBundleURLProvider.sharedSettings()?.jsBundleURL(forBundleRoot: "index",
                                                                  fallbackResource: "main")
        #else
        print("running in release mode")
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
}
