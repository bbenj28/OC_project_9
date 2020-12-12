//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Benjamin Breton on 20/10/2020.
//

import UIKit

final class WeatherViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var activityIndicatorNY: UIActivityIndicatorView!
    @IBOutlet private weak var activityIndicatorNiort: UIActivityIndicatorView!
    @IBOutlet private weak var updateButton: UIButton!
    @IBOutlet private weak var nyTemp: UILabel!
    @IBOutlet private weak var nyPicture: UIImageView!
    @IBOutlet private weak var niortTemp: UILabel!
    @IBOutlet private weak var niortPicture: UIImageView!
    
    // MARK: - Properties
    /// Service's instantiation.
    private var service = WeatherService()
    /// Enable/Disable weather's update and shows/hides activity indicator.
    private var canUpdate = false {
        didSet {
            updateButton.isEnabled = canUpdate
            updateButton.backgroundColor = canUpdate ? .systemText:.systemBg0
            updateButton.setTitle(canUpdate ? "mettre à jour":"mise à jour", for: .normal)
            updateButton.setTitleColor(canUpdate ? .systemBg0:.systemText, for: .normal)
            activityIndicatorNY.isHidden = canUpdate
            activityIndicatorNiort.isHidden = canUpdate
            nyTemp.isHidden = !canUpdate
            nyPicture.isHidden = !canUpdate
            niortPicture.isHidden = !canUpdate
            niortTemp.isHidden = !canUpdate
        }
    }
    
    // MARK: - Viewdidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeather()
    }
}

extension WeatherViewController {
    
    // MARK: - Buttons actions
    
    /// Ask weather's informations to be updated.
    @IBAction func tappedUpdateButton(_ sender: Any) {
        updateWeather()
    }
}

extension WeatherViewController {
    
    /// Update weather's informations.
    private func updateWeather() {
        canUpdate = false
        service.update { [unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let datas):
                    // display data regarding its type
                    for data in datas {
                        switch data {
                        case .nyWeather(let pictureName):
                            self.nyPicture.image = UIImage(named: pictureName)
                        case .nyTemperature(let temperature):
                            self.nyTemp.text = "\(temperature) °C"
                        case .niortWeather(let pictureName):
                            self.niortPicture.image = UIImage(named: pictureName)
                        case .niortTemperature(let temperature):
                            self.niortTemp.text = "\(temperature) °C"
                        }
                    }
                case .failure(let error):
                    // display error
                    self.nyPicture.image = UIImage(named: "xmark.octagon")
                    self.niortPicture.image = UIImage(named: "xmark.octagon")
                    self.nyTemp.text = "Echec"
                    self.niortTemp.text = "Echec"
                    self.showAlert(error: error)
                }
                self.canUpdate = true
            }
        }
    }
}
