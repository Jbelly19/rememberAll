//
//  ViewController.swift
//  rememberAll
//
//  Created by Josh Belmont on 2/20/16.
//  Copyright © 2016 Belmont. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var myImageView: UIImageView!
    let picker = UIImagePickerController()

    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
        
    }
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: nil)
        }else{
            noCamera()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "ok", style: .Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    // delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        myImageView.contentMode = .ScaleAspectFill
        myImageView.image = chosenImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

