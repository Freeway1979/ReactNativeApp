//
//  UIViewControllerExtensions.swift
//  ReactNativeStudy
//
//  Created by Andy Liu on 2020/1/14.
//  Copyright © 2020 Study. All rights reserved.
//

import Foundation
import UIKit

var vSpinner: UIView?
extension UIViewController {
  @available(iOS 13.0, *)
  func showSpinner(onView: UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let indicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicatorView.startAnimating()
        indicatorView.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(indicatorView)
            onView.addSubview(spinnerView)
        }

        vSpinner = spinnerView
    }

    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }

    func showMessageDialog(title: String, message: String, actions: [UIAlertAction]? = nil) {
        let alertController = UIAlertController(title: title, message: message, 
                                                preferredStyle: UIAlertController.Style.alert)
        if let actions = actions {
            actions.forEach { (action) in
                alertController.addAction(action)
            }
        } else {
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
        }
        present(alertController, animated: true, completion: nil)
    }

    func showEditDialog(title: String, message: String, initValue: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "name"
            textField.text = initValue
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let name = alertController.textFields?.first, let nameText = name.text {
                self.onEditDialogOkClicked(text: nameText)
            }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated:true, completion: nil)
    }

    @objc
    func onEditDialogOkClicked(text: String) {
        fatalError("onEditDialogOkClicked(text:)")
    }

    func dismissSafely(animated: Bool, completion: (() -> Void)? = nil) {
        if self.navigationController?.topViewController == self {
            self.navigationController?.popViewController(animated: animated)
            return
        }

        self.dismiss(animated: animated, completion: completion)
    }

}
