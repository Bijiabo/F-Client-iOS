//
//  UIViewControllerExtension.swift
//  F
//
//  Created by huchunbo on 15/11/7.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//
import UIKit
import Foundation

extension UIViewController {
    func __title (title: String) {
        self.title = title
        navigationItem.title = title
        tabBarController?.navigationItem.title = title
    }
    
    func __refreshTitle () {
        navigationItem.title = title
        tabBarController?.navigationItem.title = title
    }
}