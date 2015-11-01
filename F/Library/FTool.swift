//
//  FTool.swift
//  F
//
//  Created by huchunbo on 15/11/1.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import Foundation
import SwiftyJSON
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
    }
}