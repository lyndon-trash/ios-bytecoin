//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    let coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }


}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func coinManager(_ coinManager: CoinManager, didCalculateCurrency currency: Currency, rate: Money) {
        print("Exchange Rate \(currency): \(rate)")
        
        DispatchQueue.main.async {
            self.currencyLabel.text = currency
            self.bitcoinLabel.text = String(format: "%.2f", rate)
        }
    }
    
    func coinManager(_ coinManager: CoinManager, didError error: Error) {
        print("Error: \(error)")
    }
}


//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
        
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency: Currency = coinManager.currencyArray[row]
        print("Picked: \(currency)")
        coinManager.fetchBitcoinExchange(forCurreny: currency)
    }
        
}
