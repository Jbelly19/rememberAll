//
//  ViewController.swift
//  rememberAll
//
//  Created by Josh Belmont on 2/20/16.
//  Copyright © 2016 Belmont. All rights reserved.
//

import UIKit
import SwiftyDropbox

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var myImageView: UIImageView!
    let picker = UIImagePickerController()
    var oxfordUrl: String?
    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .PhotoLibrary
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
        
    }
    @IBAction func Analyze(sender: UIBarButtonItem) {

       
        
        if (Dropbox.authorizedClient == nil) {
            Dropbox.authorizeFromController(self)
        }
        
        let imageData = UIImageJPEGRepresentation(myImageView.image!, 1)
       
        
        // Drop box api shit
        
        if let client = Dropbox.authorizedClient {
            
            // Get the current user's account info
            client.users.getCurrentAccount().response { response, error in
                print("*** Get current account ***")
                if let account = response {
                    print("Hello \(account.name.givenName)!")
                } else {
                    print(error!)
                }
            }
            
            // List folder
            client.files.listFolder(path: "").response { response, error in
                print("*** List folder ***")
                if let result = response {
                    print("Folder contents:")
                    for entry in result.entries {
                        print(entry.name)
                    }
                } else {
                    print(error!)
                }
            }
            
            // Upload a file
            let fileData = imageData
            client.files.upload(path: "/image.jpg", body: fileData!).response { response, error in
               print(error)
                if let metadata = response {
                    print("*** Upload file ****")
                    print("Uploaded file name: \(metadata.name)")
                    print("Uploaded file revision: \(metadata.rev)")
                    
                    // Get file (or folder) metadata
//                    client.files.getMetadata(path: "/image.txt").response { response, error in
//                        print("*** Get file metadata ***")
//                        if let metadata = response {
//                            if let file = metadata as? Files.FileMetadata {
//                                print("This is a file with path: \(file.pathLower)")
//                                print("File size: \(file.size)")
//                            } else if let folder = metadata as? Files.FolderMetadata {
//                                print("This is a folder with path: \(folder.pathLower)")
//                            }
//                        } else {
//                            print(error!)
//                        }
//                    }
                    
//                    // Share link
                    client.sharing.createSharedLink(path: metadata.pathLower, shortUrl: false, pendingUpload: Sharing.PendingUploadMode.File).response({ (response, error) -> Void in
                        if let link = response {
                            self.oxfordUrl = link.url
                            let replaced = self.oxfordUrl!.stringByReplacingOccurrencesOfString("dl=0", withString: "raw=1")
                            self.oxfordUrl = replaced
                            self.performSegueWithIdentifier("oxford", sender: nil)
                           // print(link.url)
                        } else {
                            print(error!)
                        }
                    })
                    
                    
                   
                
                    
                
                }
            }
        }
    

        
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "oxford"){
            let oxfordViewController = segue.destinationViewController as! OxfordViewController
            
            oxfordViewController.urlOxford = self.oxfordUrl
            
            
            
            
            
            
        }
        
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

