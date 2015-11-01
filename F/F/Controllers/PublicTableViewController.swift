//
//  MainTableViewController.swift
//  RegisterAndLogIn
//
//  Created by huchunbo on 15/10/26.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import UIKit
import SwiftyJSON

class PublicTableViewController: UITableViewController {
    
    var data: JSON = JSON([]) {
        didSet {
            if data["list"].array != nil && data["table"].array == nil {
                listDataType = ListType.Single
            } else {
                listDataType = ListType.Multiple
            }
        }
    }
    var activeTextField: UITextField?
    var mode = "login"

    var listDataType = ListType.Single
    
    enum  ListType {
        case Single
        case Multiple
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupViews()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return listDataType == .Single ? 1 : data["table"].count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listDataType == .Single ? data["list"].count : data["table"][section]["list"].count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let defaultHeight: CGFloat = 44.0
        
        guard let cellData = listDataType == .Single ? data["list"][indexPath.row].dictionary : data["table"][indexPath.section]["list"][indexPath.row].dictionary else {return defaultHeight}
        guard let cellType = listDataType == .Single ? cellData["type"]?.string : cellData["type"]?.string else {return defaultHeight}
        
        switch cellType {
        case "text_field_with_label", "password_field_with_label", "text_field", "password_field", "text_field_with_button":
            return 60.0
            
        case "annotation":
            return 40.0
            
        case "block_button":
            return 50.0
        
        case "indicator", "text_field_with_label_full_width":
            return 44.0
            
        case "avatar":
            return 140.0
            
        case "blank":
            if let height = cellData["height"]?.float {
                return CGFloat(height)
            }
            return 0.0
            
        default:
            break
        }
        return defaultHeight
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cellData = listDataType == .Single ? data["list"][indexPath.row].dictionary : data["table"][indexPath.section]["list"][indexPath.row].dictionary else {return UITableViewCell()}
        guard let cellType = cellData["type"]?.string else {return UITableViewCell()}

        switch cellType {
        case "text_field_with_label":
            let cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell", forIndexPath: indexPath) as! TextFieldWithLabel_TableViewCell
            cell.label.text = cellData["label"]?.stringValue
            cell.textField.placeholder = cellData["placeHolder"]?.stringValue
            cell.backgroundColor = UIColor.clearColor()
            cell.delegate = self
            
            return cell
            
        case "password_field_with_label":
            let cell = tableView.dequeueReusableCellWithIdentifier("passwordFieldWithLabelCell", forIndexPath: indexPath) as! PasswordFieldWithLabel_TableViewCell
            cell.label.text = cellData["label"]?.stringValue
            cell.passwordField.placeholder = cellData["placeHolder"]?.stringValue
            cell.backgroundColor = UIColor.clearColor()
            cell.delegate = self
            
            return cell
            
        case "annotation":
            let cell = tableView.dequeueReusableCellWithIdentifier("annotationCell", forIndexPath: indexPath) as! Annotation_TableViewCell
            cell.label.text = cellData["text"]?.stringValue
            cell.backgroundColor = UIColor.clearColor()
            
            guard let align = cellData["align"]?.string else {return cell}
            
            switch align {
                case "left":
                cell.label.textAlignment = NSTextAlignment.Left
                
                case "right":
                cell.label.textAlignment = NSTextAlignment.Right
                
                case "center":
                cell.label.textAlignment = NSTextAlignment.Center
                
                default:
                break
            }
            
            return cell
            
        case "block_button":
            let cell = tableView.dequeueReusableCellWithIdentifier("blockButtonCell", forIndexPath: indexPath) as! BlockButton_TableViewCell
            cell.blockButton.setTitle(cellData["text"]?.stringValue, forState: UIControlState.Normal)
            cell.backgroundColor = UIColor.clearColor()
            
            return cell
            
        case "text_field":
            let cell = tableView.dequeueReusableCellWithIdentifier("textfieldCell", forIndexPath: indexPath) as! TextField_TableViewCell
            cell.textField.placeholder = cellData["placeHolder"]?.stringValue
            cell.delegate = self
            
            return cell
            
        case "password_field":
            let cell = tableView.dequeueReusableCellWithIdentifier("passwordFieldCell", forIndexPath: indexPath) as! PasswordField_TableViewCell
            cell.passwordField.placeholder = cellData["placeHolder"]?.stringValue
            cell.delegate = self
            
            return cell
            
        case "text_field_with_button":
            let cell = tableView.dequeueReusableCellWithIdentifier("textfieldWithButtonCell", forIndexPath: indexPath) as! TextFieldWithButton_TableViewCell
            cell.textField.placeholder = cellData["placeHolder"]?.stringValue
            cell.button.setTitle(cellData["buttonText"]?.stringValue, forState: UIControlState.Normal)
            cell.delegate = self
            
            return cell
            
        case "text_field_with_label_full_width":
            let cell = tableView.dequeueReusableCellWithIdentifier("textFieldWithLabelFullWidthCell", forIndexPath: indexPath) as! TextFieldWithLabelFullWidth_TableViewCell
            cell.textField.placeholder = cellData["placeHolder"]?.stringValue
            cell.label.text = cellData["label"]?.stringValue
            cell.delegate = self
            
            return cell
            
        case "avatar":
            let cell = tableView.dequeueReusableCellWithIdentifier("avatarCell", forIndexPath: indexPath) as! AvatarTableViewCell
            cell.avatarImageView.image = UIImage(named: cellData["image"]!.stringValue)
            
            return cell
            
        case "indicator":
            let cell = tableView.dequeueReusableCellWithIdentifier("indicatorCell", forIndexPath: indexPath) as! Indicator_TableViewCell
            cell.label.text = cellData["label"]?.stringValue
            cell.indicatorLabel.text = cellData["indicatorLabel"]?.stringValue
            
            return cell
            
        case "blank":
            let cell = UITableViewCell()
            cell.backgroundColor = UIColor.clearColor()
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if listDataType == .Multiple{
            if let title = data["table"][section]["sectionTitle"].string {
                return title
            }
        }
        
        return nil
    }
    
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = ViewConstants.Style.backgroundColorForTableview
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        guard let cellData = listDataType == .Single ? data["list"][indexPath.row].dictionary : data["table"][indexPath.section]["list"][indexPath.row].dictionary else {return}
        
        guard let reference = cellData["reference"]?.string else {return}
        
        let nextController = storyboard?.instantiateViewControllerWithIdentifier("MainTableViewController") as? PublicTableViewController
        nextController?.mode = reference
        navigationController?.pushViewController(nextController!, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - User Interface Functions
    private func _setupViews () {
        
        view.backgroundColor = ViewConstants.Style.backgroundColorForTableview
        //tableView.scrollEnabled = false
        
        //update title
        title = data["title"].stringValue
        
        //update navigationBarItem
        if let rightNavigationBarTitle = data["rightButtonItem"].string {
            
            let rightLabel = UILabel()
            rightLabel.attributedText = NSAttributedString(string: rightNavigationBarTitle, attributes: [
                NSFontAttributeName: UIFont.systemFontOfSize(14.0),
                NSForegroundColorAttributeName: UIColor.whiteColor()
                ])
            rightLabel.sizeToFit()
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: rightNavigationBarTitle, style: UIBarButtonItemStyle.Done,target: self, action: Selector("tapRightNavigationBarItem:"))
        }
        
        //add tap gesture
        //let viewTapGesture = UITapGestureRecognizer(target: self, action: Selector("userTapView:"))
        //view.addGestureRecognizer(viewTapGesture)
    }
    
    func tapRightNavigationBarItem(sender: UIBarButtonItem) {
        guard let referenceID = data["rightButtonReference"].string else {return}
        FTool.UI.pushFormController(navigationController, formID: referenceID)
    }
    
    func userTapView(sender: UITapGestureRecognizer) {
        if activeTextField != nil {
            activeTextField?.resignFirstResponder()
            activeTextField = nil
        }
    }
    
    func userTapBackButton(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)

    }
}
