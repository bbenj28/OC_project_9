//
//  extensionUIViewController+Alert.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 25/10/2020.
//

import UIKit
typealias AlertAction = ((UIAlertAction) -> Void)?
typealias Completion = () -> Void
typealias OptionalCompletion = Completion?

extension UIViewController {
    /// Shows an alert with the choosen parameters.
    /// -- 1. To display an error : change the error parameter only. Optional : modify the title, and add a completion handler.
    /// -- 2. To display a message with a single button OK : change parameters title, message. Optional: modify the style, and add a completion handler.
    /// -- 3. To display a Yes/No alert : change parameters title, message, yesNoActions to true, and add at least a yes or a no action. Optional : modify the style, add actions for both yes and no buttons, add a completion handler.
    /// - parameter error: Error to display (default: nil).
    /// - parameter title: Title of the alert (default: nil).
    /// - parameter message: Message to display : parameter unused for errors alerts (default: nil).
    /// - parameter style: Style of the alert box (default: .alert).
    /// - parameter yesNoActions: Alert with yes/no buttons, OK button if returns false value (default: false).
    /// - parameter yesAction: Action to do when the yes button is hitten. To use this parameter, the yesNoActions parameter has to return true (default: nil).
    /// - parameter noAction: Action to do when the no button is hitten. To use this parameter, the yesNoActions parameter has to return true (default: nil).
    /// - parameter completion: Actions to do after alert's disappearance (default: nil).
    func showAlert(error: Error? = nil, title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, yesNoActions: Bool = false, yesAction: AlertAction = nil, noAction: AlertAction = nil, completion: OptionalCompletion = nil) {
        // prepare properties to display
        let alertTitle: String
        let alertMessage: String
        let alertStyle: UIAlertController.Style
        let alertActions: [UIAlertAction]
        if let error = error {
            print(error)
            let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertActions = [action]
            if let title = title {
                alertTitle = title
            } else {
                alertTitle = "Erreur"
            }
            alertMessage = error.userMessage
            alertStyle = .alert
        } else {
            if let title = title {
                alertTitle = title
            } else {
                return
            }
            if let message = message {
                alertMessage = message
            } else {
                return
            }
            alertStyle = style
            if yesNoActions {
                let yesAction = UIAlertAction(title: "Oui", style: .default, handler: yesAction)
                let noAction = UIAlertAction(title: "Non", style: .default, handler: noAction)
                alertActions = [yesAction, noAction]
            } else {
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertActions = [action]
            }
        }
        presentAlert(title: alertTitle, message: alertMessage, style: alertStyle, actions: alertActions, completion: completion)
    }
    /// Present alert.
    /// - parameter title: Title of the alert.
    /// - parameter message: Message to display.
    /// - parameter style: Style of the alert box.
    /// - parameter actions: Actions to do for each buttons.
    /// - parameter completion: Actions to do after alert's disappearance.
    private func presentAlert(title: String, message: String, style: UIAlertController.Style, actions: [UIAlertAction], completion: OptionalCompletion) {
        let alertVc = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alertVc.addAction(action)
        }
        present(alertVc, animated: true, completion: completion)
    }
}
