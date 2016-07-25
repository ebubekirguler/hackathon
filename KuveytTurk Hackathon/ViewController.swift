//
//  ViewController.swift
//  KuveytTurk Hackathon
//
//  Created by EBUBEKIR GULER on 21/07/16.
//  Copyright © 2016 Kuveyttürk Katılım Bankası A.Ş. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var payButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        payButton.layer.borderWidth = 2.0
        payButton.layer.cornerRadius = 8
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clickedPaymentButton(sender: AnyObject) {
        
        HTTPPostAuthentication();
        
        
        
    }
    
    func HTTPPostAuthentication() {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/auth")!)
        request.HTTPMethod = "POST"
        let postString = "accountNumber=13&password=Jack"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            // print("responseString = \(responseString)")
            self.HTTPPostGsmPrePaid(responseString);
            
        }
        task.resume()
    }
    
    func HTTPPostGsmPrePaid(responseString: NSString!) {
        var accessToken="";
        
        do {
            //Convert NSString to NSData
            let myNSData = responseString.dataUsingEncoding(NSUTF8StringEncoding)!
            let responseObject = try NSJSONSerialization.JSONObjectWithData(myNSData, options: []) as! [String:AnyObject]
            let dict = responseObject["result"] as? NSDictionary;
            accessToken = dict!.objectForKey("accessToken") as! String
            
        } catch let error as NSError {
            print("error: \(error.localizedDescription)")
        }
        
        
        let headers = [
            "authorization": accessToken
        ]
        let request = NSMutableURLRequest(URL: NSURL(string: "http://localhost:3000/gsmprepaid")!)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        let postString = "number=13&amount=100"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            guard error == nil && data != nil else {                                                          // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
        }
        task.resume()
        
    }
    
    
}

