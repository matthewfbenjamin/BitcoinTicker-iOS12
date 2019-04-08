//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    var currencyIdx = 0

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        let currentCurrencyCode = Locale.current.currencyCode!
        if let indexOfCurrentCurrencyCode = currencyArray.firstIndex(of: currentCurrencyCode) {
          currencyPicker.selectRow(indexOfCurrentCurrencyCode, inComponent: 0, animated: false)
          finalURL = "\(baseURL)\(currentCurrencyCode)"
          currencyIdx = indexOfCurrentCurrencyCode
          getBitcoinData(url: finalURL)
        }
    }

    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currencyIdx = row
        finalURL = "\(baseURL)\(currencyArray[row])"
        getBitcoinData(url: finalURL)
    }

    //MARK: - Networking
    /***************************************************************/

    func getBitcoinData(url: String) {
        Alamofire.request(url, method: .get).responseJSON {
        response in
            if response.result.isSuccess {
                let responseJSON : JSON = JSON(response.result.value!)
                self.updateBitcoin(json: responseJSON)
            }
        }
    }

    //MARK: - JSON Parsing
    /***************************************************************/

    func updateBitcoin(json: JSON) {
        if let askPrice = json["ask"].double {
            bitcoinPriceLabel.text = "\(currencyArray[currencyIdx]) \(String(askPrice))"
        }
    }
}
