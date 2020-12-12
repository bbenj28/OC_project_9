//
//  TranslateViewController.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 22/10/2020.
//

import UIKit
import AVFoundation

final class TranslateViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var soundButtonOutlet: UIButton!
    @IBOutlet private weak var translatedLanguageLabel: UILabel!
    @IBOutlet private weak var resultLanguageLabel: UILabel!
    @IBOutlet private weak var translatedTextView: UITextView!
    @IBOutlet private weak var resultTextView: UITextView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var exchangeButton: UIButton!
    
    // MARK: - Properties
    
    /// Enable / Disable changing of the textview and hides/shows the activty indicator.
    private var canChangeText: Bool = false {
        didSet {
            translatedTextView.isEditable = canChangeText
            resultTextView.isSelectable = canChangeText
            activityIndicator.isHidden = canChangeText
        }
    }
    /// Property used to know when the text to translate has been changed.
    private var textHasBeenChanged = false
    /// Service used to do network calls
    private var service: TranslateService = TranslateService()
    /// Synthesizer used to hear translations.
    private let synthesizer = AVSpeechSynthesizer()
    /// Property used to display translation and handle soundButton.
    private var resultText: String = "" {
        didSet {
            soundButtonOutlet.isEnabled = resultText != ""
            resultTextView.text = resultText
        }
    }
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        canChangeText = false
        // gesture to close keyboard and ask translation
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboardWithGesture))
        view.addGestureRecognizer(gesture)
        canChangeText = true
    }
    
}

extension TranslateViewController {
    
    // MARK: Buttons actions
    
    /// Method called when user wants to exhange languages.
    @IBAction func exchangeLanguageButtonActions(_ sender: Any) {
        let resultLanguage = resultLanguageLabel.text
        let resultText = resultTextView.text
        self.resultText = translatedTextView.text
        translatedTextView.text = resultText
        resultLanguageLabel.text = translatedLanguageLabel.text
        translatedLanguageLabel.text = resultLanguage
    }
    /// Method called to hear the pronounciation of the translated text.
    @IBAction func soundButtonActions(_ sender: UIButton) {
        guard let language = getLanguage() else {
            self.displayError(ApplicationErrors.trNoLanguage)
            return
        }
        guard let text = resultTextView.text, text.count > 0 else { return }
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: language.speechCode)
        synthesizer.speak(utterance)
    }
}

extension TranslateViewController: UITextViewDelegate {
    
    // MARK: - Text view edition
    
    /// Ask user to delete or not the the textview before editing it.
    /// - parameter textView: The textview to be edited.
    func textViewDidBeginEditing(_ textView: UITextView) {
        soundButtonOutlet.isEnabled = false
        guard let text = translatedTextView.text else {
            return
        }
        if text.count > 0 {
            let yesAction: (UIAlertAction) -> Void = { _ in
                self.translatedTextView.text = ""
                self.resultText = ""
            }
            showAlert(title: "Nouvelle traduction", message: "Voulez-vous effacer le texte préexistant ?", style: .actionSheet, yesNoActions: true, yesAction: yesAction)
        }
        textHasBeenChanged = true
    }
    
}

extension TranslateViewController {
    
    // MARK: - Asking translation
    
    /// Method called when user close the keyboard with a gesture : ask translation.
    @objc private func closeKeyboardWithGesture() {
        if textHasBeenChanged {
            // close keyboard
            translatedTextView.resignFirstResponder()
            // disable textview's editing
            canChangeText = false
            // check the text and put it in an array
            guard let textArray = putTextInArray(translatedTextView.text), textArray.count > 0 else {
                canChangeText = true
                textHasBeenChanged = false
                return
            }
            // check language
            guard let language = getLanguage() else {
                self.displayError(ApplicationErrors.trNoLanguage)
                return
            }
            // translate it
            service.getTranslation(textsToTranslate: textArray, language: language, completionHandler: { [unowned self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let texts):
                        self.displayTranslation(texts)
                    case .failure(let error):
                        self.displayError(error)
                    }
                }
            })
        }
    }
    /// Display translation's result.
    /// - parameter texts: Texts to display.
    private func displayTranslation(_ texts: [String]) {
        // put texts in an array without html codes
        let newTexts: [String] = texts.map({self.decodeHTMLCodes("\($0)")})
        // put texts in a single string property
        let textToDisplay: String
        if newTexts.count > 1 {
            textToDisplay = newTexts.joined(separator: "\n")
        } else {
            textToDisplay = newTexts[0]
        }
        // display the result and enable textview's editing
        self.resultText = textToDisplay
        self.canChangeText = true
    }
    /// Get the text and put it in an array regarding each linebreaks.
    /// - parameter text: The text to translate.
    /// - returns: The array.
    private func putTextInArray(_ text: String?) -> [String]? {
        // check the text to be not empty
        guard let text = text, text != "" else {
            return nil
        }
        // search breaklines to split text
        if text.contains("\n") {
            let newText = text.split(separator: "\n").map({
                return "\($0)"
            })
            return newText
        } else {
            return [text]
        }
    }
}

extension TranslateViewController {
    
    // MARK: - Display error
    
    /// Display an error.
    /// - parameter error: The error to display.
    private func displayError(_ error: Error) {
        showAlert(error: error)
        canChangeText = true
        textHasBeenChanged = false
    }
}

extension TranslateViewController {
    
    // MARK: - Get language
    
    /// Returns the language of the result flag.
    private func getLanguage() -> TranslationLanguage? {
        guard let flag = resultLanguageLabel.text else {
            return nil
        }
        switch flag {
        case "🇺🇸":
            return .english
        case "🇫🇷":
            return .french
        default:
            return nil
        }
    }
}
