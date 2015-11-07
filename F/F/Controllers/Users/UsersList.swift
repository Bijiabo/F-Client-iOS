//
//  UsersList.swift
//  F
//
//  Created by huchunbo on 15/11/6.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//
import Alamofire
import SwiftyJSON
import UIKit

class UsersList: UITableViewController {
    
    private var _data: JSON = JSON([])

    override func viewDidLoad() {
        super.viewDidLoad()

        _getUsersList()
        
        __title("Users")
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
        let cell = UITableViewCell() //tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        cell.textLabel?.text = _data[indexPath.row]["name"].string

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
    // MARK: - network functions
    private func _getUsersList () {
        FAction.GET(path: "users", completeHandler: {
            (request, response, json, error) -> Void in
            
            if error == nil {
                self._data = json
                self.tableView.reloadData()
            }else{
                print(error)
            }
        })
    }
    
    @IBAction func taplogoutButton(sender: AnyObject) {
        FAction.logout()
        
        navigationController?.popViewControllerAnimated(true)
    }
    
}
