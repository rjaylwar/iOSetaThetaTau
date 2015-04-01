//
//  ScriptSelectViewController.swift
//  etaThetaTau
//
//  Created by RJ Aylward on 2/18/15.
//  Copyright (c) 2015 RJ Aylward. All rights reserved.
//

import UIKit

//var yearSelected:Int = 2015

class ScriptSelectViewController: UIViewController {
    
    @IBOutlet weak var button15: UIButton!
    @IBOutlet weak var button14: UIButton!
    @IBOutlet weak var button13: UIButton!
    @IBOutlet weak var button12: UIButton!
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    let recognizer = UITapGestureRecognizer(target: self, action:Selector("cancel:"))
        recognizer.numberOfTapsRequired = 1
        backgroundView.addGestureRecognizer(recognizer)
    }
    @IBAction func dismiss2012(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func dismiss2013(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismiss2014(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismiss2015(sender: AnyObject) {
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    func cancel (sender:AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}
