//
//  VideosTableViewController.swift
//  etaThetaTau
//
//  Created by RJ Aylward on 2/1/15.
//  Copyright (c) 2015 RJ Aylward. All rights reserved.
//

import AVFoundation
import UIKit


class VideosTableViewController: UITableViewController {
    
    var avPlayer:AVPlayer!
    var songObject:SongObject!
    var songsArrayLength:Int!
    var screenRect = UIScreen.mainScreen().bounds
    
    //@IBOutlet var tableView: UITableView!
    let shadow = NSShadow()
    var isPlaying = false
    var hasLoaded = false
    
    var slider:UISlider?
    //var audioSession:AVAudioSession?
    
    
    override func viewDidLoad() {
        
        shadow.shadowColor = UIColor.blackColor()
        shadow.shadowOffset = CGSize(width: -1, height: -1)
        
        var attributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "Helvetica Neue", size: 24)!,
            NSShadowAttributeName: shadow
        ]
        
            //titleTextAttributes = attributes
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if songObject.loadLyrics {
            var cell = tableView.dequeueReusableCellWithIdentifier("Lyrics Cell", forIndexPath: indexPath) as? lyricsCell
            
            if (cell == nil) {
                cell = lyricsCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Lyrics Cell")
            }
            
            avPlayer = AVPlayer(URL: NSURL(string: songObject.songUrl))
            hasLoaded = true
            
            cell?.titleLabel.text = songObject.songTitle
            cell?.webView.loadHTMLString(songObject.lyrics, baseURL: nil)
            
            cell?.playButton.tag = 1
            cell?.restartButton.tag = 3
            cell?.timeSlider.tag = 2
            
            
            cell?.timeSlider.minimumValue = 0;
            cell?.timeSlider.maximumValue = Float(CMTimeGetSeconds(self.avPlayer.currentItem.asset.duration))
            
           
            
            cell?.playButton.addTarget(self, action:Selector("buttonPressed:"), forControlEvents: .TouchUpInside)
            cell?.restartButton.addTarget(self, action:Selector("buttonPressed:"), forControlEvents: .TouchUpInside)
            cell?.timeSlider.addTarget(self, action:Selector("sliderPressed:"), forControlEvents: .TouchUpInside)
            
            slider = cell?.timeSlider
            
            var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateSlider:"), userInfo: nil, repeats: true)
            
            let audioSession = AVAudioSession.sharedInstance()
            audioSession.setActive(true, error: nil)
            var audioSessionError: NSError?
            if audioSession.setCategory(AVAudioSessionCategoryPlayback,
                error: &audioSessionError){
                    println("Successfully set the audio session")
            } else {
                println("Could not set the audio session")
            }
            
            return cell!
        } else {
        //Here we create our initial UITableViewCell variable.
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as? SongVideoCell
        
        //Here we see if we should be creating a fresh cell or reusing one.
        if (cell == nil) {
            
            //creating cell
            cell = SongVideoCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            
        }
        
        if (screenRect.size.width > screenRect.size.height) {
            cell?.webViewHorizontalCCSize.constant = CGFloat(screenRect.size.width/2) } else {
            cell?.webViewHorizontalCCSize.constant = CGFloat(screenRect.size.height/2)
        }
        self.tableView.layoutIfNeeded()
        
        songsArrayLength = songObject.videoArray.count
//        cell?.webView1.loadHTMLString("https://www.youtube.com/embed/LWTCfTGJSnE", baseURL: nil)
        
        if (indexPath.row < (songObject.videoArray.count) / 2) {
        
        let urlString:String = songObject.videoArray[2*indexPath.row]
            
        let directions:String = songObject.videoArray[2*indexPath.row + 1]
        
        let directionsString = directions.stringByReplacingOccurrencesOfString("\n", withString: "\n", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let url1 = NSURL(string: urlString)
        let request = NSURLRequest(URL: url1!)
        cell?.webView1.loadRequest(request)
        
        cell?.webView1.scrollView.scrollEnabled = false
            
        cell?.textView.text = directionsString
        
        cell?.titleView.text = songObject.nameArray[indexPath.row]
            }
        return cell!
        }
        
    }
    
    func updateSlider (sender: NSTimer) {
        
        //var progress = self.avPlayer.currentTime()
        
        if (self.avPlayer != nil) {
        
        var progress = CMTimeGetSeconds(self.avPlayer.currentTime())
        
            self.slider?.setValue(Float(progress), animated: true)} else {
            sender.invalidate()
        }
    }
    
    func sliderPressed (sender: UISlider) {
        if (sender.tag == 2) {
            
            self.avPlayer.seekToTime(CMTimeMakeWithSeconds(Float64(sender.value), avPlayer.currentTime().timescale))
        }
        
    }

    
    func buttonPressed (sender: UIButton) {
        if (sender.tag == 1) {
            
            if (!isPlaying) {
                if !self.hasLoaded {
                    avPlayer = AVPlayer(URL: NSURL(string: songObject.songUrl))
                    self.hasLoaded == true
                }
                self.avPlayer.play()
                sender.setTitle("Pause", forState: UIControlState.Normal)
                self.isPlaying = true
            } else {

                self.avPlayer.pause()
                sender.setTitle("Play", forState: UIControlState.Normal)
                self.isPlaying = false
            }
        }
        
        
        if (sender.tag == 3) {
            let item = self.avPlayer.currentItem?
            item?.seekToTime(CMTimeMake(0, 1))
        }
    }

    func play() {
        self.avPlayer.play()
        self.isPlaying = true
    }
    
    func pause() {
        self.avPlayer.pause()
        self.isPlaying = false
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if songObject.loadLyrics {
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            //let systemVersion = UIDevice.currentDevice().systemVersion();

            
            if traitCollection.horizontalSizeClass == .Compact { // compact horizontal size class
                if traitCollection.verticalSizeClass == .Compact { // compact vertical size class
                    
                    if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0 {
                        return CGFloat(screenHeight - 35)}
                        
                    else {return CGFloat(screenHeight - 64)}
                } else { // regular vertical size class
                    return CGFloat(screenHeight - 64)
                }
            } else { // regular size class
                return CGFloat(screenHeight - 64)
            }

        } else {
        
        if traitCollection.horizontalSizeClass == .Compact { // compact horizontal size class
            if traitCollection.verticalSizeClass == .Compact { // compact vertical size class
                return CGFloat(230)
            } else { // regular vertical size class
                return CGFloat(370)
            }
        } else { // regular size class
            return CGFloat(300)
            }}
    }
    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//        
//        
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if songObject.loadLyrics {return 1}
        else { songsArrayLength = (songObject.videoArray.count)
            return (songsArrayLength/2)}
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        if (self.isMovingFromParentViewController() == true){
            self.avPlayer = nil
            
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        if (event.type == UIEventType.RemoteControl) {
            if (event.subtype == UIEventSubtype.RemoteControlPlay) {
                self.play()
            } else if (event.subtype == UIEventSubtype.RemoteControlPause){
                self.pause()
            } else if (event.subtype == UIEventSubtype.RemoteControlTogglePlayPause) {
                if (self.isPlaying) {self.pause()} else {self.play()}
            }
        }
        
        
    }

}

