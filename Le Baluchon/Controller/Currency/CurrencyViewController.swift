//
//  CurrencyViewController.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 19/10/2020.
//

import UIKit

final class CurrencyViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var lastUpdateInformationsStackView: UIStackView!
    @IBOutlet private weak var refreshButton: UIButton!
    @IBOutlet private weak var rateUpdateInformationsLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var convertButton: UIButton!
    @IBOutlet private weak var startAmountTextField: UITextField!
    @IBOutlet private weak var startCurrencyLabel: UILabel!
    @IBOutlet private weak var endCurrencyLabel: UILabel!
    @IBOutlet private weak var endAmountLabel: UILabel!
    @IBOutlet private weak var exChangeButton: UIButton!
    
    // MARK: - Properties
    
    /// Currency service's instantiation.
    private let service = CurrencyConversion()
    /// Enable/Disable conversion.
    private var canConvert: Bool = false {
        didSet {
            // enable buttons and textfield
            convertButton.isEnabled = canConvert
            startAmountTextField.isEnabled = canConvert
            exChangeButton.isEnabled = canConvert
            // change buttons aspect
            convertButton.backgroundColor = canConvert ? .systemText : .systemBg3
            exChangeButton.tintColor = canConvert ? .systemText : .systemBg3
        }
    }
    /// Enable/Disable rate's update.
    private var canRefresh: Bool = false {
        didSet {
            refreshButton.isEnabled = canRefresh
            refreshButton.tintColor = canRefresh ? .systemText : .systemBg3
            // hide or show activity indicator
            activityIndicator.isHidden = canRefresh
        }
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canConvert = false
        canRefresh = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(resignKeyBoard))
        view.addGestureRecognizer(gesture)
        updateRate(false)
        setupKeyboardObservers()
    }
}

extension CurrencyViewController {
    
    // MARK: - Currency Conversion calls
    
    /// Update rate.
    /// - parameter updateForcing: has the update to be forced even if a rate has already been saved and loaded ?
    private func updateRate(_ updateForcing: Bool) {
        canConvert = false
        canRefresh = false
        service.updateRateAndGetInformations(updateForcing: updateForcing, completionHandler: { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let informations):
                    self.rateUpdateInformationsLabel.text = informations
                    self.canConvert = true
                    self.canRefresh = true
                case .failure(let error):
                    self.rateUpdateInformationsLabel.text = "le taux n'a pas pu être obtenu : pour retenter de l'obtenir, cliquer sur le bouton actualiser ci-contre"
                    self.showAlert(error: error)
                    self.canConvert = false
                    self.canRefresh = true
                }
            }
        })
    }
    /// Converts the choosen amount in the choosen currency, and displays it.
    private func convert() {
        guard let amount = startAmountTextField.text else { return }
        guard let symbol = startCurrencyLabel.text else { return }
        canConvert = false
        canRefresh = false
        service.convert(amount: amount, from: symbol, completionHandler: { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.startAmountTextField.text = data[0]
                    self.endAmountLabel.text = data[1]
                case .failure(let error):
                    self.showAlert(error: error)
                }
                self.canConvert = true
                self.canRefresh = true
            }
        })
    }
}

extension CurrencyViewController {
    
    // MARK: - Buttons
    
    /// Ask for conversion.
    /// - parameter sender: The conversion button.
    @IBAction func conversionButtonActions(_ sender: Any) {
        resignKeyBoard()
        convert()
    }
    /// Exchange start and end currencies.
    /// - parameter sender : The exchange button.
    @IBAction func exchangeCurrencyButtonActions(_ sender: Any) {
        guard let resultText = endAmountLabel.text else { return }
        guard let askingText = startAmountTextField.text else { return }
        guard let startCurrency = endCurrencyLabel.text else { return }
        guard let endCurrency = startCurrencyLabel.text else { return }
        startAmountTextField.text = resultText
        endAmountLabel.text = askingText
        startCurrencyLabel.text = startCurrency
        endCurrencyLabel.text = endCurrency
    }
    /// Refresh rate's value.
    /// - parameter sender : The refresh button.
    @IBAction func refreshButtonAction(_ sender: Any) {
        updateRate(true)
    }
}


extension CurrencyViewController {
    
    // MARK: - Keyboard's management
    
    @objc
    private func resignKeyBoard() {
        startAmountTextField.resignFirstResponder()
    }

}
