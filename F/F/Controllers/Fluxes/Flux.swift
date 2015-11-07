//
//  Flux.swift
//  F
//
//  Created by huchunbo on 15/11/7.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import UIKit
import SwiftyJSON

class Flux: UITableViewController {
    
    var id: String?
    private var _data: JSON = JSON([])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

        title = "Flux Detail"
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
        return 1
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fluxCell", forIndexPath: indexPath) as! FluxCell

        cell.textLabel?.text = _data["content"].string

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
    // MARK: - data functions
    private func loadData () {
        if let id = id {
            let requestPath: String = "fluxes/\(id)"
            
            FAction.GET(path: requestPath, completeHandler: { (request, response, json, error) -> Void in
                if error == nil {
                    self._data = json
                    self.tableView.reloadData()
                    
                    //check if it is current user's flux
                    guard let user_id = json["user_id"].int else {return}
                    if FHelper.current_user(user_id) {
                        print("you are owner!")
                    }else{
                        print("This is not your flux")
                    }
                    
                }else{
                    print(error)
                }
            })
        }
    }

}
