//
//  ChoreographyViewController.swift
//  etaThetaTau
//
//  Created by RJ Aylward on 1/31/15.
//  Copyright (c) 2015 RJ Aylward. All rights reserved.
//

import Foundation
import UIKit

class ChoreographyViewController: PFQueryTableViewController {
    
   // @IBOutlet var songTitle: UILabel!
    //@IBOutlet var tableView: UITableView!
    @IBOutlet var lyricsOrChoreo: UISegmentedControl!
    
    var loadLyrics = true
    
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        let user = NSUserDefaults.standardUserDefaults().objectForKey("user") as String
        if (user != "guest") {
            self.parseClassName = "songs" }
        else {self.parseClassName = "guest_songs"}
        
        self.pullToRefreshEnabled = true
        self.paginationEnabled = true
        self.objectsPerPage = 5
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.estimatedRowHeight = 60
        //self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return UITableViewAutomaticDimension;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
    
    override func queryForTable() -> PFQuery! {
        
        var className:String!
        let user = NSUserDefaults.standardUserDefaults().objectForKey("user") as String
        if (user != "guest") { className = "songs" } else {className = "guest_songs" }
        
        let query = PFQuery(className: className)
        
        if (self.objects.count == 0) {
            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        }
        query.orderByDescending("createdAt")
        return query
    }
    
    override func objectAtIndexPath(indexPath: NSIndexPath!) -> PFObject! {
        var object : PFObject? = nil
        if(indexPath.row < self.objects.count){
            object = self.objects[indexPath.row] as? PFObject
        }
        
        return object
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as SongCell
        if (object != nil ) {
        //cell.songTitle.text = "Hello"
        cell.songTitle.text = object.valueForKey("title") as String!
        cell.songSubtitle.text = object.valueForKey("subtitle") as String! }
        
        
        if (object.valueForKey("color_array") != nil) {
        var colorArray = object.valueForKey("color_array") as [Int]!
        
        var red = CGFloat(colorArray[0])/255.0
        var green = CGFloat(colorArray[1])/255.0
        var blue = CGFloat(colorArray[2])/255.0
            
            cell.backgroundColor = UIColor(red: red, green:green, blue: blue, alpha: 1)
            cell.accessoryView?.backgroundColor = UIColor(red: red, green:green, blue: blue, alpha: 1)
            cell.contentView.backgroundColor = UIColor(red: red, green:green, blue: blue, alpha: 1)
        
        } else {
            var red = CGFloat(18)/255.0
            var green = CGFloat(78)/255.0
            var blue = CGFloat(118)/255.0
            
            cell.backgroundColor = UIColor(red: red, green:green, blue: blue, alpha: 1)
            cell.accessoryView?.backgroundColor = UIColor(red: red, green:green, blue: blue, alpha: 1)
            cell.contentView.backgroundColor = UIColor(red: red, green:green, blue: blue, alpha: 1)
        }
        
        return cell
    }
    
    ///////////////////
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showVideos"{
            let vc = segue.destinationViewController as VideosTableViewController
            
            //let defaults = NSUserDefaults.standardUserDefaults()
            //defaults.setBool(true, forKey: "showLyrics")
            
            let indexPath = self.tableView.indexPathForSelectedRow() as NSIndexPath!
            var object1 = self.objects[indexPath.row] as PFObject
            
            var mySongObject:SongObject = SongObject()
            
            mySongObject.songTitle = object1.objectForKey("title") as NSString
            //mySongObject.songTitle = "title, woot"
            
            mySongObject.songSubtitle = object1.objectForKey("subtitle") as NSString
            
            mySongObject.videoArray = object1.objectForKey("videoArray") as [String]
            
            mySongObject.nameArray = object1.objectForKey("nameArray") as [String]
            
            //mySongObject.loadLyrics = defaults.boolForKey("showLyrics")
            
            mySongObject.loadLyrics = loadLyrics
            
            mySongObject.lyrics = object1.objectForKey("lyrics") as NSString
            
            
            if (object1.objectForKey("audioUrl") != nil) {
                mySongObject.songUrl = object1.objectForKey("audioUrl") as NSString}
            
            vc.songObject = mySongObject
            
        }
    }
    
        @IBAction func lyricsOrChoreoChanged(sender: UISegmentedControl) {
    
            println("# of Segments = \(sender.numberOfSegments)")
    
            switch sender.selectedSegmentIndex {
            case 0:
                println("first segement clicked")
                self.loadLyrics = true
            case 1:
                println("second segment clicked")
                self.loadLyrics = false
            default:
                break;
            }
        }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //super.tableView(tableView, didDeselectRowAtIndexPath: indexPath)
    }
    
    ////////////////////
    
    
   // NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    //EventViewController *destViewController = segue.destinationViewController;
    
    //PFObject *object = [self.objects objectAtIndex:indexPath.row];
    //EventObject *eventPage = [[EventObject alloc] init];
    //eventPage.title = [object objectForKey:@"title"];
    //eventPage.graphic = [object objectForKey:@"image"];
    //eventPage.tumblrLink = [object objectForKey:@"tumblrUrl"];
    
    
    
}