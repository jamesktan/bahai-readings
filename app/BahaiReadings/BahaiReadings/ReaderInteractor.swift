//
//  ReaderInteractor.swift
//  BahaiReadings
//
//  Created by James Tan on 5/31/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class ReaderInteractor: NSObject {
  
  var presenter : ReaderPresenter? = nil

  func arrayOfReaderThemes() -> NSArray {
    return DataManager.arrayOfReaderThemes()
  }
  
  func arrayOfReaderStyles() -> NSArray {
    return DataManager.arrayOfFontFamily()
  }
  
  func arrayOfReaderSizes() -> NSArray {
    return DataManager.arrayOfSizes()
  }
  
  func htmlForBook(book:String)->String {
    var urlString = "https://s3-us-west-2.amazonaws.com/bahai-reading/Epistle+To+The+Son+of+the+Wolf.html"
    var url = NSURL(string: urlString)
    var contents = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)
    return contents as! String
  }
  
  func htmlForCurrentStyle() -> String {
    var format = "<style>%@ %@ %@ </style>"
    var style = DataManager.currentStyle()
    var size = DataManager.currentSize()
    var theme = DataManager.currentTheme()
    var styleString = NSString(format: format, style, size, theme)
    return styleString as! String
  }
  
  func getCurrentSize() -> String {
    return DataManager.getCurrentSizeKey()
  }
  
  func getCurrentStyle() -> String {
    return DataManager.getCurrentStyleKey()
  }
  
  func getCurrentTheme() -> String {
    return DataManager.getCurrentThemeKey()
  }
  func getCurrentOrientation()->String {
    return DataManager.getCurrentOrientationKey()
  }
  
  func getCurrentProgress(bookHandle:String)->Float {
    return Float(0.9)
  }
  
  func getCurrentBookTitle(handle:String)->String {
    return "Wize Up Epistle"
  }
  
  func selectStyle(val:String) {
    DataManager.setCurrentKey(val, key: "family")
  }
  
  func selectTheme(val:String) {
    DataManager.setCurrentKey(val, key: "theme")
  }
  
  func selectSize(val:String) {
    DataManager.setCurrentKey(val, key: "size")
  }
  
  func selectOrientation(val:String) {
    DataManager.setCurrentKey(val, key: "orientation")
  }
  
  func setCurrentProgress(bookHandle:String, progress:Float) {
    
  }
}
