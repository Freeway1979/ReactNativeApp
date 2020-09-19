//
//  RNViewController.swift
//  ReactNativeApp
//
//  Created by Andy Liu on 2020/9/19.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation
import UIKit

protocol RNRTCViewSetup {
    func setRCTRootView(_ rtcView: RCTRootView)
}

protocol ActionSheetDelegate : class {
    func handlerAction(action: UIAlertAction)
}

typealias Parameters = [String: Any]

enum ActionID: String {
    case showMessage
    case showEditDialog
    case loadData
    case saveData
    case pushScreen
    case presentScreen
    case popScreen
    case showActionSheet
}

struct ActionOption {
    static let action = "action"
    static let parameters = "params"
    static let actionSheet = "actionSheet"
    static let items = "items"
    static let initValue = "initValue"
    struct ShowMessage {
        static let title = "title"
        static let message = "message"
    }

    struct Navigation {
        static let storyboard = "storyboard"
        static let screen = "screen"
        static let navigationParams = "navigationParams"
        static let main = "Main"
    }

}

struct AppPropertyKey {
    enum Base: String {
        case errorCode
    }

    // others
}

class RNViewController: UIViewController {
    var rctRootView: RCTRootView?
    var params: Parameters?

    var appProperties: Parameters = [:]
    static var javascriptLoaded = false
    weak var actionSheetDelegate: ActionSheetDelegate?

  @available(iOS 13.0, *)
  lazy var indicator = { () -> UIActivityIndicatorView in
        let indicatorView = UIActivityIndicatorView(style: .large)
        indicatorView.frame = self.view.bounds
        self.view.addSubview(indicatorView)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
            _ = NotificationCenter.default.addObserver(forName: NSNotification.Name.RCTJavaScriptDidLoad,
                                               object: nil, queue: nil) { _ in
            RNViewController.javascriptLoaded = true
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func loadJS(jsComponent:String?, initialProperties:Parameters?) {
        if let jsComponent = jsComponent {
            /// Load JS
            let rootView = MixerReactModule.shared.viewForModule(jsComponent, initProps: initialProperties)
            setRCTRootView(rootView)
        }
    }

    // Used to changed data async. Usually for big data
    func notifyDataChanged(data: Parameters, completion: (() -> Void)?) {
        DispatchQueue.global().async {
            self.notifyDataChangedInternal(data: data, completion: completion)
        }
    }

    private func notifyDataChangedInternal(data: Parameters, completion: (() -> Void)?) {
        // Make sure Javascript loaded
        while !RNViewController.javascriptLoaded {
            print("Waiting for Javascript Loaded")
            // Sleep on Global Thread
            Thread.sleep(forTimeInterval: 0.2)
        }
        // Make sure UI first render
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            AppNativeEventEmitter.sharedInstance().notifyDataChanged(onJS: data)
            completion?()
        }
    }
    @objc
    private func handleJSCall(options:Parameters) -> Bool {
        let action = options[ActionOption.action] as? String ?? ""
        let params = options[ActionOption.parameters] as? Parameters
        let handled = handleCommonCalls(action: action, params: params)
        if handled {
            return true
        }
        // Subclass
        return handleJSCall(action: action, params: params)
    }

    func handleJSCall(action: String, params: Parameters?) -> Bool {
        return false
    }

    private func handleCommonCalls(action: String, params: Parameters?) -> Bool {
        var handled = false
        switch action {
        case ActionID.showMessage.rawValue:
            let title = params?[ActionOption.ShowMessage.title] as? String ?? ""
            let message = params?[ActionOption.ShowMessage.message] as? String ?? ""
            showMessageDialog(title: title, message: message)
            handled = true
        case ActionID.showEditDialog.rawValue:
            let title = params?[ActionOption.ShowMessage.title] as? String ?? ""
            let message = params?[ActionOption.ShowMessage.message] as? String ?? ""
            let initValue = params?[ActionOption.initValue] as? String ?? ""
            showEditDialog(title: title, message: message, initValue: initValue)
            handled = true
        case ActionID.loadData.rawValue:
            loadData(parameters: params)
            handled = true
        case ActionID.saveData.rawValue:
            onSaveData(params: params)
            handled = true
        case ActionID.pushScreen.rawValue:
            pushOrPresentViewController(action: action, params: params)
            handled = true
        case ActionID.presentScreen.rawValue:
            pushOrPresentViewController(action: action, params: params)
            handled = true
        case ActionID.popScreen.rawValue:
            self.dismissSafely(animated: true)
            handled = true
        case ActionID.showActionSheet.rawValue:
            showActionSheet(parameters: params)
            handled = true
        default: break
        }
        return handled
    }

    internal func pushOrPresentViewController(action:String, params:Parameters?) {
        guard let screenName = params?[ActionOption.Navigation.screen] as? String else { return }
        let storyboardName = params?[ActionOption.Navigation.storyboard] as? String
        let navigationParams = params?[ActionOption.Navigation.navigationParams] as? Parameters
        let storyboard = UIStoryboard(name: storyboardName ?? ActionOption.Navigation.main, bundle: nil)
        let destViewController = storyboard.instantiateViewController(withIdentifier: "\(screenName)ViewController")
        // implement @objc func handleNavigationParams(_ params:Parameters?)
        let selector = Selector(("handleNavigationParams:"))
        if (destViewController.responds(to: selector)) {
            destViewController.perform(selector, with: navigationParams)
        }
        if (action == ActionID.pushScreen.rawValue) {
            self.navigationController?.pushViewController(destViewController, animated: true)
        } else {
            self.present(destViewController, animated: true, completion: nil)
        }
    }

    func onSaveData(params:Parameters?) {
        print(params ?? [:])
    }

    func loadData(parameters: Parameters? = nil) {
        // load from local db or network
    }
    
    func refresh(_ data: Parameters?) {
        DispatchQueue.main.async {
            self.rctRootView?.appProperties = data
        }
    }

  @available(iOS 13.0, *)
  func showLoading() {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
        }
    }

  @available(iOS 13.0, *)
  func hideLoading() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
        }
    }
    
    func showActionSheet(parameters: Parameters?) {
        if let parms = parameters?[ActionOption.actionSheet] as? Parameters {
            let title = parms[ActionOption.ShowMessage.title] as? String
            if let items = parms[ActionOption.items] as? [String] {
                let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
                for actionTitle in items {
                    alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: actionSheetDelegate?.handlerAction))
                }
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: actionSheetDelegate?.handlerAction))
                self.present(alert, animated: true, completion: nil)
            }}
    }

}

extension RNViewController: RNRTCViewSetup {
    func setRCTRootView(_ rtcView: RCTRootView) {
        view = rtcView
        rctRootView = rtcView
    }
}
