//
//  FNetwork.swift
//  F
//
//  Created by huchunbo on 15/11/16.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class FNetwork {
    class func POST (path path: String, parameters: [String : AnyObject]? = nil, host: String = Config.host, encoding: ParameterEncoding = ParameterEncoding.JSON , completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, json: SwiftyJSON.JSON, error:ErrorType?) -> Void)
    {
        Alamofire
            .request(.POST, "\(host)\(path)", parameters: parameters, encoding: ParameterEncoding.JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
            completionHandler(request: request, response: response, json: json, error: error)
        })
    }
    
    class func GET (path path: String, parameters: [String : AnyObject]? = nil, host: String = Config.host, encoding: ParameterEncoding = ParameterEncoding.JSON , completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, json: SwiftyJSON.JSON, error:ErrorType?) -> Void)
    {
        Alamofire
            .request(.GET, "\(host)\(path)", parameters: parameters, encoding: ParameterEncoding.JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
                completionHandler(request: request, response: response, json: json, error: error)
            })
    }
    
    class func DELETE (path path: String, parameters: [String : AnyObject]? = nil, host: String = Config.host, encoding: ParameterEncoding = ParameterEncoding.JSON , completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, json: SwiftyJSON.JSON, error:ErrorType?) -> Void)
    {
        Alamofire
            .request(.DELETE, "\(host)\(path)", parameters: parameters, encoding: ParameterEncoding.JSON)
            .responseSwiftyJSON({
                (request, response, json, error) in
                completionHandler(request: request, response: response, json: json, error: error)
            })
    }
    
    class func UPLOAD (path path: String, multipartFormData: MultipartFormData -> Void, host: String = Config.host, encoding: ParameterEncoding = ParameterEncoding.JSON , completionHandler: (request: NSURLRequest, response: NSHTTPURLResponse?, json: SwiftyJSON.JSON, error:ErrorType?) -> Void, failedHandler: (success: Bool, description: String)->Void)
    {
        Alamofire.upload(
            .POST,
            "\(host)\(path)",
            multipartFormData: multipartFormData,
            encodingCompletion: { encodingResult in
                var result = (success: false, description: "")
                
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseSwiftyJSON({ (request, response, json, error) in
                        completionHandler(request: request, response: response, json: json, error: error)
                    })
                case .Failure(_):
                    result.description = "upload failure."
                    failedHandler(success: result.success, description: result.description)
                }
                
            }
        )
    }

}