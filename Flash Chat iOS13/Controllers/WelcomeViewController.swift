//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

   
    @IBOutlet weak var titleLabel: UILabel!
    
    // removes nav bar from first screen (register, signin screem)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    // adds nav bar back for the screen as it was removed for the first screen as it was not needed
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        // K is a structure found in the constants.swift file, appName is a property of the structure, appName = "⚡️FlashChat" //

        titleLabel.text = K.appName
       
    }
    

}
