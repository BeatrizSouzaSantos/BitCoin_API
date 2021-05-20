//
//  ViewController.swift
//  BitcoinCurrency
//
//  Created by beatriz de souza santos on 18/05/21.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    //MARK: - Outlats
    
    @IBOutlet weak var currencyPickerView: UIPickerView!
    @IBOutlet weak var PriceLabelView: UILabel!
    
    //MARK: - Variables and Constants
    
    let apiKey = "ZDJmNGU1NTVkNWRkNDI5Nzg0ZjYyNTg3M2EzNWYyZDQ"
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(url: baseUrl)
        currencyPickerView.delegate = self
        currencyPickerView.dataSource = self
    }
    
    func formatNumberToDecimal(value:Double) -> String {
        let numberFormatter = NumberFormatter()

        // Atribuindo o locale 
        numberFormatter.locale = Locale(identifier: "pt_BR")

        // Importante para que sejam exibidas as duas casas após a vírgula
        numberFormatter.minimumFractionDigits = 2

        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value:value)) ?? "Valor indefinido"
    }
    
    func fetchData(url: String) {
        
        let url = URL(string: url)!
        var request = URLRequest (url: url)
        
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                
                self.parseJSON(json: data)
                
            } else {
                print("error")
                
            }
            
        }
        task.resume()
        
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Definindo qual moeda pela quantidade de linhas
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // retorno o numero de moedas para fazer a conversao.
        return curruncies.count
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // retorna o titulo para a selacao
        return curruncies[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        fetchData(url: url)
        
    }
    //organiza formato para JSON
    func parseJSON(json: Data) {
        do{
            
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                    
                    let askvalueString = "\(askValue)"
                    DispatchQueue.main.async {
                        
                        self.PriceLabelView.text = self.formatNumberToDecimal(value: Double(askvalueString)!)
                    }
                    print("success")
                } else {
                    print("error")
                }
            }
        } catch {
            
            print("error parsing json: \(error)")
        }
    }
    
    
}
