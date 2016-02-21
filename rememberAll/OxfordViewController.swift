//
//  OxfordViewController.swift
//  rememberAll
//
//  Created by Josh Belmont on 2/21/16.
//  Copyright © 2016 Belmont. All rights reserved.
//

import UIKit

class OxfordViewController: UIViewController {
    
    var urlOxford: String?
    var imageOxford: UIImage?

    @IBOutlet weak var oxfordImageView: UIImageView!
    @IBOutlet weak var oxfordLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        oxfordImageView.image = self.imageOxford
        
        
        
        print(urlOxford)

        let configuration = NSURLSessionConfiguration .defaultSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        
        
        
        let params = ["url" : urlOxford!] as Dictionary<String, AnyObject>
        
        let urlString = NSString(format: "https://api.projectoxford.ai/face/v1.0/detect?returnFaceId=true&returnFaceLandmarks=false&returnFaceAttributes=age");
        print("url string is \(urlString)")
        let request : NSMutableURLRequest = NSMutableURLRequest()
        request.URL = NSURL(string: NSString(format: "%@", urlString)as String)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 30
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("e42275369caf430a908390989d16da0e", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.HTTPBody  = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        let dataTask = session.dataTaskWithRequest(request)
            {
                (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? NSHTTPURLResponse, receivedData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    
                    
                    print(receivedData)
                    let json = JSON(data: receivedData)
                    if let age = json[0]["faceAttributes"]["age"].int {
                        self.oxfordLabel.text = "Your age is: \(age)!"
                    }
                    if response == "SUCCESS"
                    {
                        
                    }
                    
                default:
                    print("save profile POST request got response \(httpResponse.statusCode)")
                }
        }
        dataTask.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
