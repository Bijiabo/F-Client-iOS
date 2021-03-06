//
//  Register.swift
//  F
//
//  Created by huchunbo on 15/11/6.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import UIKit

class Register: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapRegisterButton(sender: AnyObject) {
        if
        let email = emailTextField.text,
        let name = nameTextField.text,
        let password = passwordTextField.text
        {
            FAction.register(email, name: name, password: password, completeHandler: { (success, description) -> Void in
                
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    print(description)
                }
                
            })
        }
        else
        {
            print("ui error")
        }
        
        
    }
    
}
