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
            
            Alamofire.request(.POST, "\(Config.host)request_new_token", parameters: parameters, encoding: ParameterEncoding.JSON)
                .responseSwiftyJSON({ (request, response, json, error) in
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
        Alamofire.request(.GET, "\(Config.host)check_token.json?token=\(FHelper.token)", parameters: nil, encoding: ParameterEncoding.JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
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
            })
    }
    
    class func login (email: String, password: String, completeHandler: (success: Bool, description: String)->Void ) {
        
        let parameters = [
            "email": email,
            "password": password,
            "deviceID": FTool.Device.ID(),
            "deviceName": FTool.Device.Name()
        ]
        
        Alamofire.request(.POST, "\(Config.host)request_new_token.json", parameters: parameters, encoding: ParameterEncoding.JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
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
            })
    }
    
    class func register (email: String, name: String, password: String, completeHandler: (success: Bool, description: String)->Void ) {
        
        let parameters = [
            "email": email,
            "name": name,
            "password": password,
            "password_confirmation": password
        ]
        
        //TODO: finish viewController
        Alamofire.request(.POST, "\(Config.host)users.json", parameters: parameters, encoding: ParameterEncoding.JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
                
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
            })
    }
    
    class func logout () {
        let tokenID = FHelper.tokenID
        let requestURL: String = "\(Config.host)tokens/\(tokenID).json?token=\(FHelper.token)"
        
        Alamofire.request(.DELETE, requestURL, parameters: nil, encoding: ParameterEncoding.JSON)
            .responseSwiftyJSON({
                (request, response, json, error) in
                
                print(json)
            })
    }
    
    // MARK:
    // MARK: - Get
    
    class func GET(path path: String, completeHandler: (request: NSURLRequest, response:  NSHTTPURLResponse?, json: JSON, error: ErrorType?)->Void) {
        let requestURL = "\(Config.host)\(path).json?token=\(FHelper.token)"
        
        Alamofire.request(.GET, requestURL)
            .responseSwiftyJSON({ (request, response, json, error) in
                completeHandler(request: request, response: response, json: json, error: error)
            })
    }
    
    // MARK:
    // MARK: 
    class fluxes {
        class func create(motion motion: String, content: String, image: NSData?, completeHandler: (success: Bool, description: String)->Void) {
            let requestURL: String = "\(Config.host)fluxes.json?token=\(FHelper.token)"
            let parameters = [
                "flux": [
                    "motion": motion,
                    "content": content,
                    "picture": ""
                ]
            ]
            
            print(parameters)
            print(requestURL)
            
            Alamofire.upload(
                .POST,
                requestURL,
                multipartFormData: { multipartFormData in
                    if let imageData = image {
                        multipartFormData.appendBodyPart(data: imageData, name: "flux[picture]", fileName: "xxx.jpg", mimeType: "image/jpeg")
                    }else{
                        multipartFormData.appendBodyPart(data: "".dataUsingEncoding(NSUTF8StringEncoding)!, name: "flux[picture]")
                    }
                    
                    //multipartFormData.appendBodyPart(fileURL: uploadImageURL, name: "flux[picture]")
                    
                    multipartFormData.appendBodyPart(data: motion.dataUsingEncoding(NSUTF8StringEncoding)!, name: "flux[motion]")
                    multipartFormData.appendBodyPart(data: content.dataUsingEncoding(NSUTF8StringEncoding)!, name: "flux[content]")
                },
                encodingCompletion: { encodingResult in
                    var result = (success: false, description: "")
                    
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseSwiftyJSON({ (request, response, json, error) in
                            result.success = json["success"].boolValue
                            result.description = json["description"].stringValue
                            completeHandler(success: result.success, description: result.description)
                        })
                    case .Failure(let encodingError):
                        print(encodingError)
                        result.description = "upload failure."
                        completeHandler(success: result.success, description: result.description)
                    }
                    
                }
            )
        }
    }
}