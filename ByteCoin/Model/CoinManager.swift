//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

typealias Money = Double
typealias Currency = String

class CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "14D3C306-F29F-4E21-B697-8D3E59375842"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    weak var delegate: CoinManagerDelegate?
    
    func fetchBitcoinExchange(forCurreny currency: Currency) {
        if let url = URL(string: "\(baseURL)/\(currency)") {
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.setValue(apiKey, forHTTPHeaderField: "X-CoinAPI-Key")
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    self.delegate?.coinManager(self, didError: error!)
                }
                
                let parseResult = self.parseJSON(exchangeData: data!)
                
                if let safeResult = parseResult {
                    self.delegate?.coinManager(self, didCalculateCurrency: currency, rate: safeResult.rate)
                    return
                }
                
            }
            
            task.resume()
        }
    }
    
    func parseJSON(exchangeData: Data) -> ExchangeRate? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(ExchangeRate.self, from: exchangeData)
            return decoded
        } catch {
            self.delegate?.coinManager(self, didError: error)
            return nil
        }
    }
}

protocol CoinManagerDelegate: AnyObject {
    
    func coinManager(_ coinManager: CoinManager, didCalculateCurrency: Currency, rate: Money)
    
    func coinManager(_ coinManager: CoinManager, didError: Error)
}

struct ExchangeRate: Codable {
    let rate: Money
}
