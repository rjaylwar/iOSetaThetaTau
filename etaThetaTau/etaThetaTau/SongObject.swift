//
//  SongObject.swift
//  etaThetaTau
//
//  Created by RJ Aylward on 1/31/15.
//  Copyright (c) 2015 RJ Aylward. All rights reserved.
//


class SongObject: NSObject {
    
    var songTitle:NSString = ""
    var songSubtitle:NSString = ""
    var lyrics:NSString = ""
   // var videoLink:String = ""
   // var notes:String = ""
    
    var videoArray:[String] = []
    var isHtml:Bool = true
    var nameArray:[String] = []
    var loadLyrics = true
    
    var songUrl:NSString = ""

}
