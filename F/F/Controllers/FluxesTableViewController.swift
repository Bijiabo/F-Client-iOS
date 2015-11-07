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
        
        let bijiabo = User(id: 100, name: "bijiabo", email: "bijiabo@gmail.com", valid: true)
        FHelper.current_user = bijiabo
        print(FHelper.current_user.name)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        __refreshTitle()
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
        cell.id = _data[indexPath.row]["id"].stringValue

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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        guard let segueID = segue.identifier else {return}
        
        switch segueID {
        case "toDetail":
            guard let cell = sender as? FluxesTableViewCell else {break}
            guard let id = cell.id else {break}
            guard let vc = segue.destinationViewController as? Flux else {break}
            vc.id = id
            
        default:
            break
        }
        
    }

    
    // MARK:
    // MARK: - View Functions
    private func _setupViews () {
        __title("Fluxes")
        
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log in", style: UIBarButtonItemStyle.Done ,target: self, action: Selector("showLoginView:"))
        
        FTool.UI.setupNavigationBarStyle(navigationController: navigationController)
    }
    
    func showLoginView (sender: UIBarButtonItem) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("LoginAndRegister")
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func refreshData (sender: UIBarButtonItem) {
        //_getData()
        
        print(FTool.Device.ID())
        print(hardwareDescription())
    }

    
    // MARK:
    // MARK: - Data Functions
    
    private func _getData () {
        
        FAction.GET(path: "fluxes", completeHandler: {
            (request, response, json, error) -> Void in
            
            if error == nil {
                self._data = json
                self.tableView.reloadData()
            }else{
                print(error)
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
