//
//  FTool.swift
//  F
//
//  Created by huchunbo on 15/11/1.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import Foundation
import SwiftyJSON

class FTool {
    
    class Configuration {
        
        class func form (name name: String) -> JSON {
            let fileURL = NSBundle.mainBundle().resourceURL!.URLByAppendingPathComponent("Configuration/form.json")
            guard let fileData = NSData(contentsOfURL: fileURL) else {return JSON([])}
            return JSON(data: fileData)[name]
        }
    }
}