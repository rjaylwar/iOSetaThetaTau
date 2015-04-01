//
//  LoginViewController.swift
//  etaThetaTau
//
//  Created by RJ Aylward on 2/11/15.
//  Copyright (c) 2015 RJ Aylward. All rights reserved.
//
import StoreKit
import Parse


class LoginViewController: UIViewController, UITextFieldDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    @IBOutlet weak var toBottomLayerConstraint: NSLayoutConstraint!
    @IBOutlet weak var distanceToCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var hotAboveCountConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundVIew: UIImageView!
    
    var SongFestDate:NSDate!
    
    //let EndDate = NSDate(timeIntervalSince1970:1426645800)
    
    var labelString:String!
    var password: NSString?
    
    @IBOutlet weak var countdownDesLabel: UILabel!
    
    @IBOutlet var label:UILabel!
    @IBOutlet weak var hotLabel: UILabel!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    var keyboardIsShowing = false
    
    var config1:PFConfig!
    
    var keyboardHeight:CGFloat!
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set IAPS
        if(SKPaymentQueue.canMakePayments()) {
            println("IAP is enabled, loading")
            var productID:NSSet = NSSet(objects: "com.rja.etaThetaTau.hot.donate")
            var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID)
            request.delegate = self
            request.start()
        } else {
            println("please enable IAPS")
        }
        
        let Device = UIDevice.currentDevice()
        
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        
        if (iosVersion >= 8) {
            self.SongFestDate = NSCalendar.currentCalendar().dateWithEra(1, year: 2015, month: 3, day: 17, hour: 19, minute: 30, second: 0, nanosecond: 0)!
        }
        
        if (iosVersion < 8) {self.SongFestDate = NSDate(timeIntervalSince1970:1424302344)}
        
        
        label.alpha = 0
        hotLabel.alpha = 0
        passwordField.alpha = 0
        enterButton.alpha = 0
        countdownDesLabel.alpha = 0
        
        let recognizer3 = UITapGestureRecognizer(target: self, action:Selector("hideKeyboard:"))
        recognizer3.numberOfTapsRequired = 1
        self.backgroundVIew.addGestureRecognizer(recognizer3)
        
        NSLog("Getting the latest config...");
        PFConfig.getConfigInBackgroundWithBlock {
            (var config: PFConfig!, error: NSError!) -> Void in
            if (error == nil) {
                self.config1 = config }
            else {
                self.config1 = PFConfig.currentConfig()
            }
            
            self.password = self.config1["password"] as? NSString

        }
        
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
        
        for subview in self.view.subviews
        {
            if (subview.isKindOfClass(UITextField))
            {
                var textField = subview as UITextField
                textField.addTarget(self, action: "textFieldDidReturn:", forControlEvents: UIControlEvents.EditingDidEndOnExit)
                
                textField.addTarget(self, action: "textFieldDidBeginEditing:", forControlEvents: UIControlEvents.EditingDidBegin)
                
            }
        }
            
        }
    override func viewWillAppear(animated: Bool) {
        
        let screenSize:CGRect = UIScreen.mainScreen().bounds
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        updateBottomConstrain()
    }
    
//    override func viewWillLayoutSubviews() {
//        updateBottomConstrain()
//    }
    
    override func viewDidAppear(animated: Bool) {
        
        updateBottomConstrain()
        
        UIView.animateWithDuration(0.15, animations: {
            self.label.alpha = 1
            self.hotLabel.alpha = 1
            self.passwordField.alpha = 1
            self.enterButton.alpha = 1
            self.countdownDesLabel.alpha = 1
        })
    }
        
    func update() {
        
        let calendar = NSCalendar.currentCalendar()
        let units = NSCalendarUnit.DayCalendarUnit | NSCalendarUnit.HourCalendarUnit | NSCalendarUnit.MinuteCalendarUnit | NSCalendarUnit.SecondCalendarUnit
        
        let date = calendar.components(units, fromDate: NSDate(), toDate:SongFestDate, options: nil)
        
        let format = NSNumberFormatter()
        format.minimumIntegerDigits = 2
        
        let countDownString = "\(format.stringFromNumber(date.day)!.toInt()!)d:\(format.stringFromNumber(date.hour)!.toInt()!)h:\(format.stringFromNumber(date.minute)!.toInt()!)m:\(format.stringFromNumber(date.second)!.toInt()!)s"
        
        //println(countDownString)
        label.text = countDownString
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        self.keyboardIsShowing = true
        
        if let info = notification.userInfo {
            self.keyboardHeight = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue().size.height
            //self.arrangeViewOffsetFromKeyboard()
            
            self.updateBottomConstrain()
            
            //self.updateViewConstraints()
        }
        
    }
    
    func updateBottomConstrain() {
        
        if (keyboardIsShowing) {
            UIView.animateWithDuration(0.15, animations: {self.distanceToCenterConstraint.constant = self.keyboardHeight + 107})
        }
        
        else {
            let screenSize:CGRect = UIScreen.mainScreen().bounds
            let orientation = UIApplication.sharedApplication().statusBarOrientation
            
            if (UIInterfaceOrientationIsPortrait(orientation)) {
                UIView.animateWithDuration(0.05, animations: {
                    self.distanceToCenterConstraint.constant = ((screenSize.height)/2-10)})
                println("\((screenSize.height)/2-10) h is the position of the Constraint")
            } else {
                UIView.animateWithDuration(0.05, animations: {
                    self.distanceToCenterConstraint.constant = ((screenSize.height)/2-45) })
                println("\((screenSize.height)/2-45) w is the position of the Constraint")
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        self.keyboardIsShowing = false
        self.updateBottomConstrain()
        //self.returnViewToInitialFrame()
    }
    
    
    @IBAction func textFieldDidReturn(textField: UITextField!)
    {
        if (passwordField.text == self.password) {
            NSUserDefaults.standardUserDefaults().setObject("hottie", forKey: "user")
            self.performSegueWithIdentifier("toTonighView", sender: self)
        } else if (passwordField.text.rangeOfString("+") != nil) {
            
            var channel = passwordField.text.stringByReplacingOccurrencesOfString("+", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.addUniqueObject(channel, forKey: "channels")
            currentInstallation.saveInBackgroundWithBlock({(success: Bool!, error: NSError!) -> Void in
                if success! {
                    self.passwordField.text = "Successfully Subscribed"
                } else {
                    self.passwordField.text = "Error, Try Again"
                NSLog("%@", error)
                }})
        } else if (passwordField.text.rangeOfString("-") != nil) {
            
            var channel = passwordField.text.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            let currentInstallation = PFInstallation.currentInstallation()
            currentInstallation.removeObject(channel, forKey: "channels")
            currentInstallation.saveInBackgroundWithBlock({(success: Bool!, error: NSError!) -> Void in
                if success! {
                    self.passwordField.text = "Successfully Unsubscribed"
                } else {
                    self.passwordField.text = "Error, Try Again"
                    NSLog("%@", error)
                }})
            
        } else {passwordField.text = "Incorrect Password"}

        
        textField.resignFirstResponder()
        //self.activeTextField = nil
        self.updateBottomConstrain()
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        //self.activeTextField = textField
        
        if(self.keyboardIsShowing)
        {
           self.updateBottomConstrain()
        }
    }
    
    @IBAction func guestButton(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setObject("guest", forKey: "user")}
    
    func hideKeyboard(sender: AnyObject) {
        
            self.passwordField.resignFirstResponder()
    }
    
    
    
    func buyProduct() {
        println("buy " + p.productIdentifier)
        var pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    //3
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println("product request")
        var myProduct = response.products
        
        for product in myProduct {
            println("product added")
            println(product.productIdentifier)
            println(product.localizedTitle)
            println(product.localizedDescription)
            println(product.price)
            
            list.append(product as SKProduct)
        }
        
        //outRemoveAds.enabled = true
        //outAddCoins.enabled = true
    }
    
    // 4
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        println("transactions restored")
        
        var purchasedItemIDS = []
        for transaction in queue.transactions {
            var t: SKPaymentTransaction = transaction as SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.rja.etaThetaTau.hot.donate":
                println("donated!")
                //removeAds()
            default:
                println("IAP not setup")
            }
            
        }
    }
    
    // 5
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("add paymnet")
        
        for transaction:AnyObject in transactions {
            var trans = transaction as SKPaymentTransaction
            println(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                println("buy, ok unlock iap here")
                println(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.rja.etaThetaTau.hot.donate":
                    println("donate")
                    changeDonateText()
                default:
                    println("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                println("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                println("default")
                break;
                
            }
        }
    }
    
    // 6
    func finishTransaction(trans:SKPaymentTransaction)
    {
        println("finish trans")
    }
    
    //7
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!)
    {
        println("remove trans");
    }
    
    @IBOutlet weak var donateButton: UIButton!
    
    @IBAction func donate(sender: AnyObject) {
        
        let alertView = UIAlertController(title: "Donate", message: "Would you like to donate $1.99 to help with the continued development of this app? This will not upgrade/change the functionality in any way and is completely optional. Pressing donate will start the in app purchase process.", preferredStyle: .Alert)
        
        alertView.addAction(UIAlertAction(title: "No Thanks", style: .Cancel, handler: nil))
        
        alertView.addAction(UIAlertAction(title: "Donate", style: .Default, handler: { (alertAction) -> Void in
            self.donateFunc()
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func donateFunc() {
        
        for product in list {
            var prodID = product.productIdentifier
            if(prodID == "com.rja.etaThetaTau.hot.donate") {
                p = product
                buyProduct()
                break;
            }
        }
    }
    
    func changeDonateText() {
        donateButton.setTitle("Thanks for Donating, You're Awesome!", forState: UIControlState.Normal)
    }
    
    
}
