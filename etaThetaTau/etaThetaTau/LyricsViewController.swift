//
//  LyricsViewController.swift
//  etaThetaTau
//
//  Created by RJ Aylward on 2/1/15.
//  Copyright (c) 2015 RJ Aylward. All rights reserved.
//

class LyricsViewController: UIViewController {

    @IBOutlet var webView1: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myHTMLString:String! = "<body> <h1>Blank Space - Lyrics</h1><p>My first paragraph.</p><p>[Verse 1]<br>Nice to meet you<br>Where you been?<br> I could show you incredible things<br></body>"
        
        webView1.loadHTMLString(myHTMLString, baseURL: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
