//
//  FirstViewController.swift
//  etaThetaTau
//
//  Created by RJ Aylward on 1/28/15.
//  Copyright (c) 2015 RJ Aylward. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var hotFontLabel: UILabel!
    @IBOutlet weak var firstViewLabel: UILabel!
    @IBOutlet weak var secondViewLabel: UILabel!
    
    @IBOutlet weak var upCarrot: UIButton!
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var imageBackgroundLabel: UILabel!
    @IBOutlet var backgroundView: UIView!

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var bottomTextView: UITextView!
    
    //constraints...
    //var objectDownloaded = PFObject()
    var upDrinks: Bool = true
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var drinksTopConstraint: NSLayoutConstraint!
    
    var upSalt: Bool = true
    @IBOutlet weak var saltyLabel: UILabel!
    @IBOutlet weak var saltyTopConstraint: NSLayoutConstraint!
    
    var upSweet: Bool = true
    @IBOutlet weak var sweetLabel: UILabel!
    @IBOutlet weak var sweetTopConstraint: NSLayoutConstraint!
    
    var viewHOTD: Bool = false
    var themePic:UIImage!
    var hottiePic:UIImage!
    
    var timesLoaded = 0.0
    
    var user:String!
    var urlToOpen = "instagram://user?username=etathetatau"
    
    // things to reset the view
    
    
    let switchViewObject1 = switchViewObject()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = NSUserDefaults.standardUserDefaults().objectForKey("user") as String
        
        let filteredSubviews = self.view.subviews.filter({
            $0.isKindOfClass(UIImageView) })
        for view in filteredSubviews  {
            let recognizer = UITapGestureRecognizer(target: self, action:Selector("openInstagram:"))
            recognizer.numberOfTapsRequired = 2
            view.addGestureRecognizer(recognizer)
        
        }
        
        let rotateTrasform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(M_PI))
        
        upCarrot.transform = rotateTrasform
        
        timesLoaded = 0.0
        webView.alpha = 0
        
        addLabelGuestureRecognizers()
        downloadObj()
        
        webView.delegate = self
        
        let recognizer2 = UISwipeGestureRecognizer(target: self, action:Selector("switchView:"))
        recognizer2.direction = UISwipeGestureRecognizerDirection.Left | UISwipeGestureRecognizerDirection.Right
        self.imageView.addGestureRecognizer(recognizer2)
        
        let recognizer3 = UITapGestureRecognizer(target: self, action:Selector("reload:"))
            recognizer3.numberOfTapsRequired = 1
        self.hotFontLabel.addGestureRecognizer(recognizer3)
        
        firstViewLabel.alpha = 1.0
        secondViewLabel.alpha = 0.0
        
        //UITabBar.appearance().selectedImageTintColor = UIColor(red: 8, green: 53, blue: 81, alpha: 1)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let RefreshInterval: NSTimeInterval = 2.0 * 60.0 * 60.0
        struct DateSingleton {
            static var lastFetchedDate: NSDate? = nil
        }
        let date: NSDate? = DateSingleton.lastFetchedDate;
        if date == nil ||
            date!.timeIntervalSinceNow * -1.0 > RefreshInterval {
                
                downloadObj()
                DateSingleton.lastFetchedDate = NSDate()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("animateAllLabels"), userInfo: self, repeats: false)
        
        sweetDown(self)
        saltyDown(self)
        drinksDown(self)
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func openInstagram(sender: AnyObject){
        let url = NSURL(string:urlToOpen)
        if(UIApplication.sharedApplication().canOpenURL(url!)) {
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    
    func getDataFromUrl(urL:NSURL, completion: ((data: NSData?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(urL) { (data, response, error) in
            completion(data: NSData(data: data))
            }.resume()
    }
    
    func downloadImage(url:NSURL){
        println("Started downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                println("Finished downloading \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                //self.imageView.image = UIImage(data: data!)
                self.switchViewObject1.tonightImage = UIImage(data:data!)
                
                UIView.transitionWithView(self.imageView,
                    duration:0.3,
                    options: .TransitionCrossDissolve,
                    animations: { self.imageView.image = self.switchViewObject1.tonightImage },
                    completion: nil)
            }
        }
    }
    
    func downloadHottieImage(url:NSURL){
        println("Started downloading hottie image \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
        getDataFromUrl(url) { data in
            dispatch_async(dispatch_get_main_queue()) {
                println("Finished downloading  hottie image \"\(url.lastPathComponent!.stringByDeletingPathExtension)\".")
                //self.imageView.image = UIImage(data: data!)
                self.switchViewObject1.hotdImage = UIImage(data:data!)
            }
        }
    }
    
    func drinksDown(sender: AnyObject){
        
        if self.upDrinks {
            self.drinksTopConstraint.constant = 1 }
        else {self.drinksTopConstraint.constant = -30}
        self.drinkLabel.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.2, delay: 0.0, options:.CurveEaseOut, animations: {
            self.drinkLabel.layoutIfNeeded()
            },completion: { finished in
                if (self.upDrinks) {self.upDrinks = false}
                else {self.upDrinks = true}
            }
        )}
    
    func saltyDown(sender: AnyObject){
        
        if self.upSalt {
            self.saltyTopConstraint.constant = 1 }
        else {self.saltyTopConstraint.constant = -30}
        self.saltyLabel.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.2, delay: 0.0, options:.CurveEaseOut, animations: {
            self.saltyLabel.layoutIfNeeded()
            },completion: { finished in
                if (self.upSalt) {self.upSalt = false}
                else {self.upSalt = true}
            }
        )}
    
    func sweetDown(sender: AnyObject){
        
        if self.upSweet {
            self.sweetTopConstraint.constant = 1 }
        else {self.sweetTopConstraint.constant = -30}
        self.sweetLabel.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.2, delay: 0.0, options:.CurveEaseOut, animations: {
            self.sweetLabel.layoutIfNeeded()
            },completion: { finished in
                if (self.upSweet) {self.upSweet = false}
                else {self.upSweet = true}
            }
        )}
    
    func animateAllLabels (){
        sweetDown(self)
        saltyDown(self)
        drinksDown(self)
    }
    
    func reload(sender: AnyObject) {
        
        if (self.sweetLabel.text == "So Hot!") {
            downloadObj()
            setHotdView()
        } else {
            downloadObj() }
    }
    
    
    func downloadObj (){
        var query = PFQuery(className:"tonight")
        query.orderByDescending("createdAt")
        //query.cachePolicy = kPFCachePolicyCacheThenNetwork
        //var object = query.getFirstObject()
        query.getFirstObjectInBackgroundWithBlock({
            (object:PFObject!, error:NSError!)  in
            
            //self.objectDownloaded = object
            //object.pinWithName("tonightObject")
            
            if (object != nil) {
                
                NSLog("object was not nil, downloadObj() is running")
                
                NSLog("%@", object.objectForKey("heading") as NSString)

                self.switchViewObject1.tonightHeading = object.objectForKey("heading") as String
                self.headingLabel.text = self.switchViewObject1.tonightHeading
            
                self.switchViewObject1.tonightLeftString = object.objectForKey("sweet_snack") as String
                self.leftLabel.text = self.switchViewObject1.tonightLeftString
            
                self.switchViewObject1.tonightMiddleString = object.objectForKey("salty_snack") as String
                self.middleLabel.text = self.switchViewObject1.tonightMiddleString
                
                self.switchViewObject1.tonightRightString = object.objectForKey("drinks") as String
                self.rightLabel.text = self.switchViewObject1.tonightRightString
            
                let hotdDescriptionArray = object.objectForKey("hotd_description_array") as [String]
                
                //let hotdDescriptionArray = object.objectForKey("hotd_description") as String
                
                
                
                    self.switchViewObject1.hotdDescription = hotdDescriptionArray[0].stringByReplacingOccurrencesOfString("\n", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                //self.switchViewObject1.hotdDescription = hotdDescriptionArray.stringByReplacingOccurrencesOfString("\n", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                self.switchViewObject1.hotdHeading = object.objectForKey("hotdName") as String
                
                let descriptionStringArray = object.objectForKey("description_array") as [String]
                
                if (self.user != "guest") {
                
                    self.switchViewObject1.tonightDescription = descriptionStringArray[0].stringByReplacingOccurrencesOfString("\n", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil) }
                
                else { self.switchViewObject1.tonightDescription = "Only HOT members can view messages from HOT Leadership. As a guest you do not have access to them."}
                
                //let originalString = object.objectForKey("description") as String
                
                //self.switchViewObject1.tonightDescription = originalString.stringByReplacingOccurrencesOfString("\n", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
                if (object.objectForKey("image_was_clicked_url") as String? != nil && object.objectForKey("image_was_clicked_url") as String? != "") {
                    self.urlToOpen = object.objectForKey("image_was_clicked_url") as String}
                
                let isHtml = object.objectForKey("isHtml") as Bool
                
                if (isHtml) {
                    self.bottomTextView.text = self.switchViewObject1.tonightDescription
                } else {
                    self.bottomTextView.text = self.switchViewObject1.tonightDescription
                }
            
                if (object["image_url"] != nil) {
                    //let imageUrl = object.objectForKey("image_url") as String!
                    let checkedUrl = NSURL(string:object["image_url"] as String)
                    self.downloadImage(checkedUrl!)
                }
                
                self.firstViewLabel.alpha = 1.0
                self.secondViewLabel.alpha = 0.0
            
                if (object["image_file"] != nil) {
                    let file = object.objectForKey("image_file") as PFFile
                    //self.imageView.file = file
                    
                    println("attempting to download pfimage file")
                    
                    file.getDataInBackgroundWithBlock({
                        (imageData: NSData!, error: NSError!) -> Void in
                        if (error != nil) {
                            let image = UIImage(data:imageData)
                            println(image)
                            self.imageView.image = image}
                        })
                    
                }
                
//                if (object["instagram_vid_url"] != nil && object["instagram_vid_url"] as String != "") {
//                    
//                    println("loading video in webview")
//                    
//                    //let instagramUrlText = object.objectForKey("instagram_vid_url") as String
//                    let instagramUrlText = "http://distilleryvesper4-8.ak.instagram.com/711349fcb07c11e3aa4d12bed4c9a5f4_101.mp4"
//                    
//                    let instaUrl = NSURL(string: instagramUrlText)
//                    let urlRequest = NSURLRequest(URL: instaUrl!)
//                    self.webView.loadRequest(urlRequest)
//                    self.webView.scrollView.scrollEnabled = false
//                }
            
                if ((object["hotd_image_url"]) != nil) {
                    let hotd_url = NSURL(string:object["hotd_image_url"] as String)
                    self.downloadHottieImage(hotd_url!)
                }
            }
        })
    }
    
    func setHotdView () {
        
    
        viewHOTD = true
        
        headingLabel.text = switchViewObject1.hotdHeading
        bottomTextView.text = switchViewObject1.hotdDescription
        
        leftLabel.text = "HOTTIE"
        middleLabel.text = "OF THE"
        rightLabel.text = "DAY"
        sweetLabel.text = "So Hot!"
        saltyLabel.text = "So Sweaty!"
        drinkLabel.text = "So Sweet!"
        
        firstViewLabel.alpha = 0.0
        secondViewLabel.alpha = 1.0
        
        UIView.transitionWithView(self.imageView,
            duration:0.3,
            options: .TransitionCrossDissolve,
            animations: { self.imageView.image = self.switchViewObject1.hotdImage },
            completion: nil)
        
        NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: Selector("animateAllLabels"), userInfo: self, repeats: false)
        animateAllLabels()
        //imageView.image = hottiePic
    }
    
    func resetTonightView() {
        
        viewHOTD = false

        headingLabel.text = switchViewObject1.tonightHeading
        bottomTextView.text = switchViewObject1.tonightDescription
        leftLabel.text = switchViewObject1.tonightLeftString
        middleLabel.text = switchViewObject1.tonightMiddleString
        rightLabel.text = switchViewObject1.tonightRightString
        
        sweetLabel.text = "~ Sweet ~"
        saltyLabel.text = "~ Salty ~"
        drinkLabel.text = "~ Drinks ~"
        
        
        firstViewLabel.alpha = 1.0
        secondViewLabel.alpha = 0.0
        
        UIView.transitionWithView(self.imageView,
            duration:0.3,
            options: .TransitionCrossDissolve,
            animations: { self.imageView.image = self.switchViewObject1.tonightImage },
            completion: nil) //}
        
        NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: Selector("animateAllLabels"), userInfo: self, repeats: false)
        animateAllLabels()
            
            //imageView.image = themePic
    }
    
    func switchView(sender: AnyObject) {
        if viewHOTD {
            resetTonightView()
            //viewHOTD = false
        } else {
            setHotdView()
            //viewHOTD = true
        }
    }
    
    func addLabelGuestureRecognizers() {
        
        let recognizer3 = UITapGestureRecognizer(target: self, action:Selector("sweetDown:"))
        recognizer3.numberOfTapsRequired = 1
        leftLabel.addGestureRecognizer(recognizer3)
        
        let recognizer1 = UITapGestureRecognizer(target: self, action:Selector("saltyDown:"))
        recognizer1.numberOfTapsRequired = 1
        middleLabel.addGestureRecognizer(recognizer1)
        
        let recognizer2 = UITapGestureRecognizer(target: self, action:Selector("drinksDown:"))
        recognizer2.numberOfTapsRequired = 1
        rightLabel.addGestureRecognizer(recognizer2)
        
        let recognizer4 = UISwipeGestureRecognizer(target: self, action:Selector("sweetDown:"))
        recognizer4.direction = UISwipeGestureRecognizerDirection.Down
        leftLabel.addGestureRecognizer(recognizer4)
        
        let recognizer5 = UISwipeGestureRecognizer(target: self, action:Selector("saltyDown:"))
        recognizer5.direction = UISwipeGestureRecognizerDirection.Down
        middleLabel.addGestureRecognizer(recognizer5)
        
        let recognizer6 = UISwipeGestureRecognizer(target: self, action:Selector("drinksDown:"))
        recognizer6.direction = UISwipeGestureRecognizerDirection.Down
        rightLabel.addGestureRecognizer(recognizer6)
        
        let recognizer9 = UISwipeGestureRecognizer(target: self, action:Selector("sweetDown:"))
        recognizer9.direction = UISwipeGestureRecognizerDirection.Up
        leftLabel.addGestureRecognizer(recognizer9)
        
        let recognizer7 = UISwipeGestureRecognizer(target: self, action:Selector("saltyDown:"))
        recognizer7.direction = UISwipeGestureRecognizerDirection.Up
        middleLabel.addGestureRecognizer(recognizer7)
        
        let recognizer8 = UISwipeGestureRecognizer(target: self, action:Selector("drinksDown:"))
        recognizer8.direction = UISwipeGestureRecognizerDirection.Up
        rightLabel.addGestureRecognizer(recognizer8)
        
        let recognizer10 = UISwipeGestureRecognizer(target: self, action:Selector("sweetDown:"))
        recognizer10.direction = UISwipeGestureRecognizerDirection.Up
        sweetLabel.addGestureRecognizer(recognizer10)
        
        let recognizer11 = UISwipeGestureRecognizer(target: self, action:Selector("saltyDown:"))
        recognizer11.direction = UISwipeGestureRecognizerDirection.Up
        saltyLabel.addGestureRecognizer(recognizer11)
        
        let recognizer12 = UISwipeGestureRecognizer(target: self, action:Selector("drinksDown:"))
        recognizer12.direction = UISwipeGestureRecognizerDirection.Up
        drinkLabel.addGestureRecognizer(recognizer12)
    }
    
    func webViewDidStartLoad(webView : UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        println("AA")
    }
    
    func webViewDidFinishLoad(webView : UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        println("BB")
        
        self.webView.alpha = 0.5
        
        UIView.animateWithDuration(0.15, animations: {
            self.imageView.alpha = 0
        })
        
        UIView.animateWithDuration(0.15, animations: {
            self.webView.alpha = 1.0 })
    }
    
    @IBAction func upArrowAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    
}
