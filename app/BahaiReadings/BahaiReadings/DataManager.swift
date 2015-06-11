//
//  DataManager.swift
//  BahaiReadings
//
//  Created by James Tan on 5/31/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class DataManager: NSObject {
  class func arrayOfReaderThemes() -> NSArray {
    return ["theme_light","theme_dark","theme_sunset","theme_midnight"]
  }
  
  class func arrayOfFontFamily() -> NSArray {
    return ["style_serif","style_sansserif"]
  }
  
  class func arrayOfSizes() -> NSArray {
    return ["font_size0","font_size1", "font_size2","font_size3","font_size4","font_size5"]
  }
  
  class func currentStyle() -> String {
    var path = NSBundle.mainBundle().pathForResource("fonts", ofType: "plist")
    var dictionary : NSDictionary = NSDictionary(contentsOfFile: path!)!
    var css : String = dictionary.objectForKey(DataManager.getCurrentStyleKey()) as! String
    return css
  }
  
  class func currentSize() -> String {
    var path = NSBundle.mainBundle().pathForResource("fonts", ofType: "plist")
    var dictionary : NSDictionary = NSDictionary(contentsOfFile: path!)!
    var css : String = dictionary.objectForKey(DataManager.getCurrentSizeKey()) as! String

    return css
  }
  
  class func currentTheme() -> String {
    var path = NSBundle.mainBundle().pathForResource("fonts", ofType: "plist")
    var dictionary : NSDictionary = NSDictionary(contentsOfFile: path!)!
    var css : String = dictionary.objectForKey(DataManager.getCurrentThemeKey()) as! String

    return css
  }
  class func currentOrientation() -> String {
    return DataManager.getCurrentOrientationKey()
  }
  
  // MARK: Get Keys for Reader
  
  class func getCurrentStyleKey() -> String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("family")
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("style_serif",key: "family")
      return "style_serif"
    }
  }
  
  class func getCurrentThemeKey() -> String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("theme")
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("theme_light", key:"theme")
      return "theme_light"
    }
  }

  class func getCurrentSizeKey() -> String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("size")
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("font_size0", key: "size")
      return "font_size0"
    }
  }
  
  class func getCurrentOrientationKey()->String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("orientation")
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("vertical", key: "orientation")
      return "vertical"
    }
  }
  
  class func setCurrentKey(value: String, key:String) {
    NSUserDefaults.standardUserDefaults().setValue(value, forKey: key)
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  
  // Reminder Keys
  
  class func getReminderKey()->String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("schedule")
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("never", key: "schedule")
      return "never"
    }

  }
  
  class func getReminderTimeKey()->String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("schedule")
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("0", key: "scheduleTime")
      return "0"
    }
    
  }

  
  class func getCounterKey(key:String)->String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(key)
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("0", key: key)
      return "0"
    }
  }
  
  // Reader
  class func getCurrentlyReading()->String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("currentlyReading")
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("nothing", key: "currentlyReading")
      return "nothing"
    }
    
  }

  // Downloading and Gallery
  
  class func getDownloadPath() -> NSString {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
    let pathDownloads = paths.stringByAppendingPathComponent("Downloads") as NSString
    return pathDownloads
  }

  class func loadOrCreatePath()-> NSString {
    // Get or Create the Path
    var path = getDownloadPath() //Documents/Download/
    var exists = NSFileManager.defaultManager().fileExistsAtPath(path as String)
    if !exists {
      NSFileManager.defaultManager().createDirectoryAtPath(path as String, withIntermediateDirectories: true, attributes: nil, error: nil)
    }
    NSLog("path at: %@", path)
    return path as NSString
    
  }
  
  class func downloadFileToPlist(url: NSString, title: String, handle:String, author:String, cover:String) -> NSString {
    //Get the Download Folder
    var path = loadOrCreatePath()
    
    // Download the COntents at the URL
    var urlObj : NSURL = NSURL(string: url as String)!
    var urlData : NSData = NSData(contentsOfURL: urlObj)!
    var urlDataToString = NSString(data: urlData, encoding: NSUTF8StringEncoding)
    
    // Create the PLIST
    var dictionary : NSMutableDictionary = NSMutableDictionary()
    dictionary.setObject(title, forKey: "bookTitle")
    dictionary.setObject(handle, forKey: "bookHandle")
    dictionary.setObject(author, forKey: "bookAuthor")
    dictionary.setObject(cover, forKey: "bookCover")
    dictionary.setObject("0", forKey: "bookProgress")
    dictionary.setObject(urlDataToString!, forKey: "bookData")
    
    // Save it to File
    var filePath = path.stringByAppendingPathComponent(handle+".plist")
    dictionary.writeToFile(filePath, atomically: true)
    println(filePath)
    return filePath
  }

  
  class func downloadFromURL(handle:String, url:String) {
    
  }
  

}
