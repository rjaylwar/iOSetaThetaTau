//
//  SecondViewController.swift
//  etaThetaTau
//
//  Created by RJ Aylward on 1/28/15.
//  Copyright (c) 2015 RJ Aylward. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var yearButton: UIButton!
    var config1:PFConfig!
    var user:String!
    var currentYear:Int!
    var script:NSString?
    var script2012:NSString?
    var script2013:NSString?
    var script2014:NSString?
    var guestScript:NSString?
    var hasLoaded:Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        hasLoaded = false
        currentYear = 2015
        
        user = NSUserDefaults.standardUserDefaults().objectForKey("user") as String
        webView.alpha = 0
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.blackColor()
        shadow.shadowOffset = CGSize(width: -1, height: -1)
        
        var script: NSString? = "<!DOCTYPE html> <html> <body bgcolor=\"#0C4E76\"> <font color=\"white\" face=\"Helvetica Neue Light\"> <h>Script is loading...</h> <p>As a guest you will be able to view this year's script after the final performance of the HOT show. We want to ensure that it is a suprise for everyone!</p> </body> </html>"
        self.webView.loadHTMLString(script, baseURL: nil)
        var attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 24)!,
            NSShadowAttributeName: shadow
        ]
        self.navBar.titleTextAttributes = attributes
        
        NSLog("Getting the latest config...");
        PFConfig.getConfigInBackgroundWithBlock {
            (var config: PFConfig!, error: NSError!) -> Void in
            
            if (error == nil) {
                self.config1 = config }
            else {
                self.config1 = PFConfig.currentConfig()
            }
            
            self.script = self.config1["script"] as? NSString
            self.guestScript = self.config1["guestScript"] as? NSString
            self.script2012 = self.config1["script2012"] as? NSString
            self.script2013 = self.config1["script2013"] as? NSString
            self.script2014 = self.config1["script2014"] as? NSString
            
            //self.hasLoaded = true
            
            if (self.user != "guest") {
                self.webView.loadHTMLString(self.script, baseURL: nil)
                println("loading 2015 from download")
            
            } else {
                self.webView.loadHTMLString(self.guestScript, baseURL: nil)
                println("loading guest script from download")
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func webViewDidStartLoad(webView : UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        println("AA")
    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        println("BB")
        
        UIView.animateWithDuration(0.2, animations: {
            self.webView.alpha = 1.0
        })

        
    }
    
    @IBAction func year2012segue(segue:UIStoryboardSegue) {
        currentYear = 2012
        yearButton.setTitle("2012", forState: UIControlState.Normal)
        updateScript()
    }
    
    @IBAction func year2013Segue(segue:UIStoryboardSegue) {
        
        currentYear = 2013
        yearButton.setTitle("2013", forState: UIControlState.Normal)
        updateScript()
    }
    
    @IBAction func year2014segue(segue:UIStoryboardSegue) {
        currentYear = 2014
        yearButton.setTitle("2014", forState: UIControlState.Normal)
        updateScript()
    }
    
    
    @IBAction func year2015segue(segue:UIStoryboardSegue) {
        currentYear = 2015
        yearButton.setTitle("2015", forState: UIControlState.Normal)
        updateScript()
    }
    
    func updateScript () {
    
        if (currentYear == 2015) {
            if (self.user != "guest") {
                self.webView.loadHTMLString(self.script, baseURL: nil)}
            else {self.webView.loadHTMLString(self.guestScript, baseURL: nil)
            }
            println("loading 2015")
        }
        
        if (currentYear == 2014) {
            self.webView.loadHTMLString(self.script2014, baseURL: nil)
            println("loading 2014")
        }
        if (currentYear == 2013) {
            self.webView.loadHTMLString(self.script2013, baseURL: nil)
            println("loading 2013")
        }
        if (currentYear == 2012) {
            self.webView.loadHTMLString(self.script2012, baseURL: nil)
            println("loading 2012")
        }
    
    }


}

