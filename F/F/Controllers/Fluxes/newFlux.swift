//
//  newFlux.swift
//  F
//
//  Created by huchunbo on 15/11/10.
//  Copyright © 2015年 TIDELAB. All rights reserved.
//

import UIKit

class newFlux: UIViewController {

    @IBOutlet weak var motionTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    var imageView: UIImageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapPublishButton(sender: AnyObject) {
        let motion: String = motionTextField.text!
        let content: String = contentTextView.text
        let images: NSData? = imageView.image != nil ? UIImageJPEGRepresentation(imageView.image!, 1.0) : nil
        
        FAction.fluxes.create(motion: motion, content: content, image: images, completeHandler: {
            (success, description) -> Void in
            if success {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        })
    }

    @IBAction func tapCameraButton(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }

}

extension newFlux: UINavigationControllerDelegate {
    
}

extension newFlux: UIImagePickerControllerDelegate {
    
    func rotateImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.Up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.drawInRect(CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        self.dismissViewControllerAnimated(true, completion: nil)
        print(info, terminator: "")
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = rotateImage(image)
        }
        

    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
