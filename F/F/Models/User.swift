//
//  User.swift
//  F
//
//  Created by huchunbo on 15/11/7.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import Foundation

class User {
    let id: Int
    var name: String
    var email: String
    var valid: Bool
    
    init (id: Int, name: String, email: String, valid: Bool = true) {
        
        self.id = id
        self.name = name
        self.email = email
        self.valid = valid
    }
}