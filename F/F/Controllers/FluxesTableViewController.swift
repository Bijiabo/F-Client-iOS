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
        configureTableView()
        _setupViews()
        getData()
        
        FStatus.addFStatusObserver(name: FConstant.String.FStatus.loginStatus, observer: self)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: Selector("doRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl!.attributedTitle = NSAttributedString(string: "pull to refresh")
        tableView.addSubview(refreshControl!)
        tableView.sendSubviewToBack(refreshControl!)
    }
    
    deinit {
        FStatus.removeFStatusObserver(name: FConstant.String.FStatus.loginStatus, observer: self)
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
        let currentData = _data[indexPath.row]
        let id = currentData["id"].stringValue
        if let pictureURL = currentData["picture"]["url"].string {
            let cell = tableView.dequeueReusableCellWithIdentifier("fluxImageCell", forIndexPath: indexPath) as! FluxImageCell
            cell.label?.text = currentData["content"].string
            cell.image_view.kf_setImageWithURL(NSURL(string: "\(Config.host)\(pictureURL)")!)
            cell.id = id
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("fluxCell", forIndexPath: indexPath) as! FluxCell
            cell.label?.text = currentData["content"].string! + id
            cell.id = id
            return cell
        }
    }

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

        if FHelper.logged_in {
            tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: UIBarButtonItemStyle.Done, target: self, action: Selector("newFlux:"))
        }else{
            tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log in", style: UIBarButtonItemStyle.Done ,target: self, action: Selector("showLoginView:"))
        }
        
        FTool.UI.setupNavigationBarStyle(navigationController: navigationController)
    }
    
    func showLoginView (sender: UIBarButtonItem) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("LoginAndRegister")
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func newFlux (sender: UIBarButtonItem) {
        let vc = storyboard!.instantiateViewControllerWithIdentifier("newFlux")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func refreshData (sender: UIBarButtonItem) {
        //_getData()
        
        print(FTool.Device.ID())
        print(hardwareDescription())
    }
    
    // MARK:
    // MARK: - Data Functions
    
    func getData (completeHandler: (()->Void)? = nil) {
        
        FAction.GET(path: "fluxes", completeHandler: {
            (request, response, json, error) -> Void in
            
            if error == nil {
                self._data = json
                self.tableView.reloadData()
            }else{
                print(error)
            }
            
            completeHandler?()
        })
        
    }
}

extension FluxesTableViewController: FStatus_LoginObserver {
    func FStatus_didLogIn() {
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New", style: UIBarButtonItemStyle.Done, target: self, action: Selector("newFlux:"))
    }
    
    func FStatus_didLogOut() {
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log in", style: UIBarButtonItemStyle.Done ,target: self, action: Selector("showLoginView:"))
    }
}



extension FluxesTableViewController {
    // do refresh
    func doRefresh() {
        getData()
        refreshControl?.endRefreshing()
    }
}

extension FluxesTableViewController {
    // configure tableView
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 30.0
    }
}

extension FluxesTableViewController {
    //edit actions
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "✕") { (rowAction, indexPath) -> Void in
            let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! FluxesTableViewCell
            FAction.fluxes.destroy(id: cell.id!)
            
            var dataCache = self._data.arrayValue
            dataCache.removeAtIndex(indexPath.row)
            self._data = JSON(dataCache)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        }
        
        let collectButton = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "★") { (rowAction, indexPath) -> Void in
            
        }
        collectButton.backgroundColor = UIColor(red:0.99, green:0.82, blue:0.07, alpha:1)

        return FHelper.current_user(self._data[indexPath.row]["user_id"].intValue) ? [collectButton, deleteButton] : [collectButton]
    }
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func rowAction_test(rowAction rowAction: UITableViewRowAction, indexPath: NSIndexPath) -> Void {
        tableView.setEditing(false, animated: true)
    }
}
