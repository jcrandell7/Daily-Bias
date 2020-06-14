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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UITextView {
    func alignTextVerticallyInContainer() {
        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        self.contentInset.top = topCorrect
    }
}
