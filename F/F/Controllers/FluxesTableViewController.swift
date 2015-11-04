//
//  FluxesTableViewController.swift
//  F
//
//  Created by huchunbo on 15/11/1.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KeychainAccess

class FluxesTableViewController: UITableViewController {
    
    private var _data: JSON = JSON([])
    
    let keychain = Keychain(service: "com.bijiabo")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupViews()
        _getData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // test
        keychain["token"] = "01234567-89ab-cdef-0123-456789abcdef"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return _data.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fluxes", forIndexPath: indexPath) as! FluxesTableViewCell

        cell.textLabel?.text = _data[indexPath.row]["content"].string

        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK:
    // MARK: - View Functions
    private func _setupViews () {
        navigationItem.title = "Fluxes"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log in", style: UIBarButtonItemStyle.Done ,target: self, action: Selector("showLoginView:"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: Selector("refreshData:"))
        
        //update navigationBar style
        let navigationBar = navigationController?.navigationBar
        navigationBar?.backIndicatorImage = nil
        navigationBar?.translucent = false
        navigationBar?.barTintColor = ViewConstants.Style.mainColor
        navigationBar?.tintColor = UIColor.whiteColor()
        
        //update title
        navigationBar?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    }
    
    func showLoginView (sender: UIBarButtonItem) {
        FTool.UI.pushFormController(navigationController, formID: "login")
    }
    
    func refreshData (sender: UIBarButtonItem) {
        //_getData()
        
        print(FTool.Device.ID())
    }

    // MARK:
    // MARK: - Data Functions
    
    private func _getData () {
        Alamofire.request(.GET, "http://localhost:3000/fluxes.json")
            .responseSwiftyJSON({ (request, response, json, error) in
                if error == nil {
                    self._data = json
                    self.tableView.reloadData()
                }
            })
    }
    
    private func _login () {
        let parameters = [
            "email": "bijiabo@gmail.com",
            "password": "password"
        ]
        
        Alamofire.request(.POST, "http://localhost:3000/request_new_token", parameters: parameters, encoding: ParameterEncoding.JSON)
            .responseSwiftyJSON({ (request, response, json, error) in
                print(error)
                print(response)
                if error == nil {
                    print(json)
                }
            })
        
    }
}
