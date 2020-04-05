//
//  ViewController.swift
//  Daily Bias
//
//  Created by Apple on 4/3/20.
//  Copyright © 2020 Jordan Crandell. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var bias: UIImageView!
    
    // this is accessing our bundle extension declared in the Bundle-Decoding.swift file to decode our JSON file FROM "quotes.json" and decoding it using our [Quote] model and putting it into that format and assigning that array to quotes.
    let biases = Bundle.main.decode([Bias].self, from: "cognitiveBiases.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    var shareBias: Bias?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (allowed, error) in
            if allowed {
                self.configureAlerts()
            }
        }
    }
    
    func updateBias() {
        guard let backgroundImageName = images.randomElement() else {
            fatalError("Unable to read an image.")
        }
        
        background.image = UIImage(named: backgroundImageName)
        guard let selectedBias = biases.randomElement() else {
            fatalError("Unable to read a quote.")
        }
        
        // - MARK: Bias Text formatting
        shareBias = selectedBias
        let insetAmount: CGFloat = 25//250
        let drawBounds = bias.bounds.inset(by: UIEdgeInsets(top: insetAmount, left: insetAmount, bottom: insetAmount, right: insetAmount))
        var quoteRect = CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        var fontSize: CGFloat = 30//120
        var font: UIFont
        var attrs: [NSAttributedString.Key: Any]!
        var str: NSAttributedString!
        while true {
            font = UIFont(name: "Georgia-Italic", size: fontSize)!
            attrs = [.font: font, .foregroundColor: UIColor.white]
            str = NSAttributedString(string: selectedBias.text, attributes: attrs)
            navigationItem.title = selectedBias.title.uppercased()
            quoteRect = str.boundingRect(with: CGSize(width: drawBounds.width, height: .greatestFiniteMagnitude),
                                         options: .usesLineFragmentOrigin, context: nil)
            if quoteRect.height > drawBounds.height {
                fontSize -= 4
            } else {
                break
            }
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.opaque = false
        let renderer = UIGraphicsImageRenderer(bounds: quoteRect.insetBy(dx: -30, dy: -30), format: format)
        bias.image = renderer.image { ctx in
            for i in 1...5 {
                ctx.cgContext.setShadow(offset: .zero, blur: CGFloat(i) * 2, color: UIColor.black.cgColor)
                str.draw(in: quoteRect)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateBias()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateBias()
    }
    // MARK: - Sharing
    @IBAction func shareTapped(_ sender: UIButton) {
        guard let bias = shareBias else {
            fatalError("Attempting to share a non-exsistent quote.")
        }
        
        let shareMessage = "\"\(bias.title)\" - \(bias.text)"
        let ac = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
        ac.popoverPresentationController?.sourceView = sender
        present(ac, animated: true)
    }
    
    // MARK: - Push Notifications
    func configureAlerts() {
        let center = UNUserNotificationCenter.current()
        //remove any notifications already showing
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
        let shuffled = biases.shuffled()
        for i in 1...7 {
            let content = UNMutableNotificationContent()
            content.title = shuffled[i].title
            content.body = shuffled[i].text
            var dateComponents = DateComponents()
            dateComponents.day = i
            if let alertDate = Calendar.current.date(byAdding: dateComponents, to: Date()){
                var alertComponents = Calendar.current.dateComponents([.day, .month, .year], from: alertDate)
                alertComponents.hour = 10
                //comment out line below to test
                let trigger = UNCalendarNotificationTrigger(dateMatching: alertComponents, repeats: false)
                // to test notifications (7 notifications at 5 second intervals) uncomment line below.
                //                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(i) * 5, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request) { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

