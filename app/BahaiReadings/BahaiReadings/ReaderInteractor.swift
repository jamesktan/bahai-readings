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
  
  func htmlForBook(book:String?)->String {
//    var urlString = "https://s3-us-west-2.amazonaws.com/bahai-reading/Epistle+To+The+Son+of+the+Wolf.html"
//    var url = NSURL(string: urlString)
//    var contents = NSString(contentsOfURL: url!, encoding: NSUTF8StringEncoding, error: nil)
    if book == nil {
      var contents = "<html><head><style></style></head><body style='text-align:center'><br><br><h1>No Writing Selected</h1> <BR><hr><BR> <h2>Go to the Library and select or download a writing.</h2></body></html>"
      return contents as String
    } else {
      var contents = BookService.htmlForBookHandle(book!)
      return contents
    }
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
  
  func getCurrentProgress(bookHandle:String?)->Float {
    if bookHandle == nil {
      return Float(0.0)
    } else {
      var progressString : NSString = BookService.progressForBookHandle(bookHandle!) as NSString
      var progressVal : Float = progressString.floatValue
      return progressVal
    }
  }
  
  func getCurrentBookTitle(handle:String?)->String {
    if handle == nil {
      return "None"
    } else {
      return BookService.titleForBookHandle(handle!)
    }
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
  
  func setCurrentProgress(bookHandle:String?, progress:Float) {
    if bookHandle != nil {
      BookService.saveProgress(bookHandle!, progress: progress)
    }
  }
}
