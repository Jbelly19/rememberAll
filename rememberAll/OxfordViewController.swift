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
    @IBOutlet weak var emotionLabel: UILabel!
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
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.oxfordLabel.text = "Your age is: \(age)!"
                        })
                    }
                    if response == "SUCCESS"
                    {
                        
                    }
                    
                default:
                    print("save profile POST request got response \(httpResponse.statusCode)")
                }
        }
        dataTask.resume()
        
        
        
        
        
        /////
        
        
    
        
        let urlStringEmotion = NSString(format: "https://api.projectoxford.ai/emotion/v1.0/recognize");
        
        let emotionRequest : NSMutableURLRequest = NSMutableURLRequest()
        emotionRequest.URL = NSURL(string: NSString(format: "%@", urlStringEmotion)as String)
        emotionRequest.HTTPMethod = "POST"
        emotionRequest.timeoutInterval = 30
        emotionRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        emotionRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        emotionRequest.addValue("5edeb49f43ed4e82862ba09068570969", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        emotionRequest.HTTPBody  = try! NSJSONSerialization.dataWithJSONObject(params, options: [])
        
        let dataTaskEmotion = session.dataTaskWithRequest(emotionRequest)
            {
                (let data: NSData?, let response: NSURLResponse?, let error: NSError?) -> Void in
                // 1: Check HTTP Response for successful GET request
                guard let httpResponse = response as? NSHTTPURLResponse, receivedEmotionData = data
                    else {
                        print("error: not a valid http response")
                        return
                }
                
                switch (httpResponse.statusCode)
                {
                case 200:
                    
                    
                    
                    print(receivedEmotionData)
                    
                    
               
                    
                    let json = JSON(data: receivedEmotionData)
                    print("JSON data is \(json)")
                    let anger = json[0]["scores"]["anger"].double
                    let contempt = json[0]["scores"]["contempt"].double
                    let disgust = json[0]["scores"]["disgust"].double
                    let fear = json[0]["scores"]["fear"].double
                    let happiness = json[0]["scores"]["happiness"].double
                    let neutral = json[0]["scores"]["neutral"].double
                    let sadness = json[0]["scores"]["sadness"].double
                    let suprise = json[0]["scores"]["suprise"].double
                    print(happiness)
                    
                
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        if(anger > 0.5){
                            
                            self.emotionLabel.text = "You are angry"
                        }
                        else if(contempt > 0.5){
                            self.emotionLabel.text = "You're showing contempt"
                        }
                        else if(disgust > 0.5){
                            self.emotionLabel.text = "You're showing disgust"
                        }
                        else if(fear > 0.5){
                            self.emotionLabel.text = "You are afraid"
                        }
                        else if(happiness > 0.5){
                            self.emotionLabel.text = "You are happy!"
                        }
                        else if(neutral > 0.5){
                            self.emotionLabel.text = "You seem neutral"
                        }
                        else if(sadness > 0.5){
                            self.emotionLabel.text = "You seem sad"
                        }
                        else if(suprise > 0.5){
                            self.emotionLabel.text = "You seem surprised"
                        }
                        else{
                            self.emotionLabel.text = "Could not read emotion \(happiness)"
                        }
                    })
                    
                    
                    

                    
                    
                    if response == "SUCCESS"
                    {
                        //fuck marcus
                    }
                    
                default:
                    print("save profile POST request got response \(httpResponse.statusCode)")
                }
        }
        dataTaskEmotion.resume()
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
