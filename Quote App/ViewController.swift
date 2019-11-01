//
//  ViewController.swift
//  Quote App
//  For VandyHacks, with love.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var quoteTextView: UITextView!
    @IBOutlet weak var vhLabel: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    
    @IBOutlet weak var colorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuote()
    }
    
    // Load a quote using the URLSession framework to get data returned from Quotes REST API
    private func setupQuote() {
        guard let url = URL(string: "http://quotes.rest/qod.json") else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: {(data, reponse, error) in
            do {
                // Parse the JSON by accessing multiple levels of dictionaries to get the quote and author
                if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    guard let quotes = (jsonResult["contents"] as? [String: Any])?["quotes"] as? [Any],
                        let firstQuote = quotes[0] as? [String: Any],
                        let quoteText = firstQuote["quote"] as? String,
                        let quoteAuthor = firstQuote["author"] as? String else { return }
                    
                    // Change the text view to display quote on the main thread
                    DispatchQueue.main.async {
                        self.quoteTextView.text = "\(quoteText)\n\n- \(quoteAuthor)"
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }

    @IBAction func changeColor(_ sender: UIButton) {
        let randomColor = generateColor()
        self.vhLabel.textColor = randomColor
        self.hpLabel.textColor = randomColor
    }
    
    private func generateColor() -> UIColor {
        let randomRed = CGFloat.random(in: 0...1)
        let randomGreen = CGFloat.random(in: 0...1)
        let randomBlue = CGFloat.random(in: 0...1)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
}

