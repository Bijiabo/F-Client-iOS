//
//  FStatusProtocols.swift
//  F
//
//  Created by huchunbo on 15/11/10.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import Foundation

@objc protocol FStatusObserver: class {
}

@objc protocol FStatus_LoginObserver: FStatusObserver {
    optional func FStatus_didLogIn ()
    optional func FStatus_didLogOut ()
}