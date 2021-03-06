//
//  BiasDefinitionViewController.swift
//  Daily Bias
//
//  Created by jordan on 6/13/20.
//  Copyright © 2020 Jordan Crandell. All rights reserved.
//

import UIKit

class BiasDefinitionViewController: UIViewController {
    
    var bias: Bias?
    @IBOutlet weak var BiasDefinitionUITextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BiasDefinitionUITextView.alignTextVerticallyInContainer()
        BiasDefinitionUITextView.text = bias?.text
        self.title = bias?.title
        // Do any additional setup after loading the view.
    }
    
    @IBAction func ShareTapped(_ sender: UIButton) {
        guard let selectedBias = bias else {
            fatalError("Unable to read a quote.")
        }
        
        let shareBias = selectedBias
        let bias = shareBias
           let shareMessage = "\"\(bias.title)\" - \(bias.text)"
           let ac = UIActivityViewController(activityItems: [shareMessage], applicationActivities: nil)
           ac.popoverPresentationController?.sourceView = sender
           present(ac, animated: true)
    }

}
extension UITextView {
    func alignTextVerticallyInContainer() {
        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        self.contentInset.top = topCorrect
    }
}
