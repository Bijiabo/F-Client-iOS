//
//  FTool.swift
//  F
//
//  Created by huchunbo on 15/11/1.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import Foundation
import SwiftyJSON
import KeychainAccess
import UIKit

class FTool {
    
    class Configuration {
        
        class func form (name name: String) -> JSON {
            let fileURL = NSBundle.mainBundle().resourceURL!.URLByAppendingPathComponent("Configuration/form.json")
            guard let fileData = NSData(contentsOfURL: fileURL) else {return JSON([])}
            return JSON(data: fileData)[name]
        }
        
    }
    
    class UI {
        class func pushFormController (navigationController: UINavigationController?, formID: String, storyBoardName: String = "Main") {
            let viewController = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewControllerWithIdentifier("PublicTableViewController") as! PublicTableViewController
            viewController.data = FTool.Configuration.form(name: formID)
            navigationController?.pushViewController(viewController, animated: true)
        }
        
        class func setupNavigationBarStyle (navigationController navigationController: UINavigationController?) {
            //update navigationBar style
            let navigationBar = navigationController?.navigationBar
            navigationBar?.backIndicatorImage = nil
            navigationBar?.translucent = false
            navigationBar?.barTintColor = ViewConstants.Style.mainColor
            navigationBar?.tintColor = UIColor.whiteColor()
            
            //update title
            navigationBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
    }
    
    class Device {
        class func ID () -> String {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            
            if let id = userDefaults.objectForKey("ApplicationUniqueIdentifier") as? String {
                return id
            }else{
                let UUID = NSUUID().UUIDString
                userDefaults.setObject(UUID, forKey: "ApplicationUniqueIdentifier")
                userDefaults.synchronize()
                
                return UUID
            }
        }
        
        class func Name () -> String {
            var deviceName = "iOS Device"
            if let device_name = hardwareDescription() {
                deviceName = device_name
            }
            
            return deviceName
        }
    }
    
    // MARK:
    // MARK: - keychain
    
    class keychain {
        class func defaultKeychain () -> Keychain {
            return Keychain(service: "com.bijiabo")
        }
        
        class func token () -> String {
            if let token = FTool.keychain.defaultKeychain()["token"] {
                return token
            }
            return ""
        }
        
        class func tokenID () -> String {
            if let token = FTool.keychain.defaultKeychain()["tokenID"] {
                return token
            }
            return ""
        }
    }
    
    
}
