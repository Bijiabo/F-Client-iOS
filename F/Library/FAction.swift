//
//  FAction.swift
//  F
//
//  Created by huchunbo on 15/11/4.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

class FAction: NSObject {
    subscript(request: String) -> AnyObject? {
        if let value = self.valueForKey(request) {
            return value
        }
        
        return nil
    }
    
    let _actions = [
        "login": {
            (params: [AnyObject], delegate: UIViewController) in
            
            if params.count < 1 {return}
            guard let userInputData = params[0] as? [String: String] else {return}
            
            let parameters = userInputData
            
            FNetwork.POST(path: "request_new_token", parameters: parameters, completionHandler: { (reqest, response, json, error) -> Void in
                if error == nil {
                    if !json["error"].boolValue {
                        print("login success!")
                    }else{
                        print("login error:(")
                    }
                    print(json)
                }
            })
        },
        "register": {
            (params: [AnyObject], delegate: UIViewController) in
            
            
        }
    ]
    
    func run (action: String, params: [AnyObject], delegate: UIViewController) {
        
        _actions[action]?(params, delegate)
    }
    
    // MARK:
    // MARK: actions
    class func checkLogin (completeHandler: (success: Bool, description: String)->Void ) {
        FNetwork.GET(path: "check_token.json?token=\(FHelper.token)") { (request, response, json, error) -> Void in
            var success: Bool = false
            var description: String = error.debugDescription
            if error == nil {
                success = json["success"].boolValue
                if !success {
                    description = json["description"].stringValue
                } else {
                    description = json["description"].stringValue
                }
                
                FHelper.current_user = User(id: json["user"]["id"].intValue , name: json["user"]["name"].stringValue, email: json["user"]["email"].stringValue, valid: true)
            }
            
            completeHandler(success: success, description: description)
        }
    }
    
    class func login (email: String, password: String, completeHandler: (success: Bool, description: String)->Void ) {
        
        let parameters = [
            "email": email,
            "password": password,
            "deviceID": FTool.Device.ID(),
            "deviceName": FTool.Device.Name()
        ]
        
        FNetwork.POST(path: "request_new_token.json", parameters: parameters) { (request, response, json, error) -> Void in
            var success: Bool = false
            var description: String = error.debugDescription
            
            if error == nil {
                success = !json["error"].boolValue
                if !success {
                    description = json["description"].stringValue
                }
                
                //save token
                FHelper.setToken(id: json["token"]["id"].stringValue, token: json["token"]["token"].stringValue)
                FHelper.current_user = User(id: json["token"]["user_id"].intValue , name: json["name"].stringValue, email: json["email"].stringValue, valid: true)
            }
            
            completeHandler(success: success, description: description)
        }
    }
    
    class func register (email: String, name: String, password: String, completeHandler: (success: Bool, description: String)->Void ) {
        
        let parameters = [
            "email": email,
            "name": name,
            "password": password,
            "password_confirmation": password
        ]
        
        //TODO: finish viewController
        FNetwork.POST(path: "users.json", parameters: parameters) { (request, response, json, error) -> Void in
            var success: Bool = false
            var description: String = String()
            
            if error == nil {
                success = !json["error"].boolValue
                if !success {
                    description = json["description"].stringValue
                    
                    completeHandler(success: success, description: description)
                } else {
                    FAction.login(email, password: password, completeHandler: completeHandler)
                }
            } else {
                description = error.debugDescription
                completeHandler(success: success, description: description)
            }
        }
    }
    
    class func logout () {
        FNetwork.DELETE(path: "tokens/\(FHelper.tokenID).json?token=\(FHelper.token)") { (request, response, json, error) -> Void in
            print(json)
        }
    }
    
    // MARK: - Get
    
    class func GET(path path: String, completeHandler: (request: NSURLRequest, response:  NSHTTPURLResponse?, json: JSON, error: ErrorType?)->Void) {
        FNetwork.GET(path: "\(path).json?token=\(FHelper.token)") { (request, response, json, error) -> Void in
            completeHandler(request: request, response: response, json: json, error: error)
        }
    }
    
    // MARK: 
    class fluxes {
        // create
        class func create(motion motion: String, content: String, image: NSData?, completeHandler: (success: Bool, description: String)->Void) {
            FNetwork.UPLOAD(path: "fluxes.json?token=\(FHelper.token)",
                multipartFormData: { (multipartFormData) -> Void in
                    if let imageData = image {
                        multipartFormData.appendBodyPart(data: imageData, name: "flux[picture]", fileName: "xxx.jpg", mimeType: "image/jpeg")
                    }else{
                        multipartFormData.appendBodyPart(data: "".dataUsingEncoding(NSUTF8StringEncoding)!, name: "flux[picture]")
                    }
                    //multipartFormData.appendBodyPart(fileURL: uploadImageURL, name: "flux[picture]")
                    multipartFormData.appendBodyPart(data: motion.dataUsingEncoding(NSUTF8StringEncoding)!, name: "flux[motion]")
                    multipartFormData.appendBodyPart(data: content.dataUsingEncoding(NSUTF8StringEncoding)!, name: "flux[content]")
                },
                completionHandler: { (request, response, json, error) -> Void in
                    completeHandler(success: json["success"].boolValue, description: json["description"].stringValue)
                },
                failedHandler: {(success: Bool, description: String) in
                    completeHandler(success: success, description: description)
                }
            )
        }
        
        // destroy
        class func destroy(id id: String, completeHandler: (success: Bool, description: String)->Void = {(success: Bool, description: String) in }) {
            FNetwork.DELETE(path: "fluxes/\(id).json", parameters: ["token": FHelper.token]) { (request, response, json, error) -> Void in
                var success: Bool = false
                var description: String = String()
                
                if error == nil {
                    success = !json["error"].boolValue
                    description = json["description"].stringValue
                    completeHandler(success: success, description: description)
                } else {
                    description = error.debugDescription
                    completeHandler(success: success, description: description)
                }
            }
        }
    }
}