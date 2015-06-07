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
  
  class func getCounterKey(key:String)->String {
    var val : AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(key)
    if val != nil {
      return val as! String
    } else {
      setCurrentKey("0", key: key)
      return "0"
    }
  }
  

}
