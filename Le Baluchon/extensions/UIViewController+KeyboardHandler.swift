//
//  UIViewController+keyboardHandler.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 16/11/2020.
//

import UIKit

extension UIViewController {
    /// Setting up observers to move view when keyboard appears.
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    /// Manage view when keyboard appears.
    @objc
    private func keyboardWillChange(notification: NSNotification) {
        if let controller = self as? CurrencyViewController {
            // get the keyboard's sizes
            if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue)?.cgRectValue {
                if notification.name == UIResponder.keyboardWillShowNotification ||
                    notification.name == UIResponder.keyboardWillChangeFrameNotification {
                    // if keyboard appears, move navigation controller's view
                    navigationController?.view.frame.origin.y = -(keyboardRect.height - (view.frame.height - controller.lastUpdateInformationsStackView.frame.maxY))
                } else {
                    // if keyboard disappears, move navigation controller's view to its origin
                    navigationController?.view.frame.origin.y = 0
                }
            }
        }
        
    }
}
