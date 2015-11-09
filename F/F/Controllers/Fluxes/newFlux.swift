//
//  newFlux.swift
//  F
//
//  Created by huchunbo on 15/11/10.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import UIKit

class newFlux: UIViewController {

    @IBOutlet weak var motionTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapPublishButton(sender: AnyObject) {
        let motion: String = motionTextField.text!
        let content: String = "Hello,world!"
        
        FAction.fluxes.create(motion: motion, content: content) { (success, description) -> Void in
            print(success)
        }
    }

    

}
