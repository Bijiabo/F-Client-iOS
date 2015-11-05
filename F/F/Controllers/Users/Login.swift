//
//  Login.swift
//  F
//
//  Created by huchunbo on 15/11/6.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class Login: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapLoginButton(sender: AnyObject) {
        guard let email = emailTextfield.text else {return}
        guard let password = passwordField.text else {return}

        FAction.login(email, password: password, completeHandler: {
            (success: Bool, description: String) in
            
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(description)
            }
            
        })
        
    }
    
    
}
