//
//  BookService.swift
//  BahaiReadings
//
//  Created by James Tan on 6/6/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class BookService: NSObject {
  
  struct container {
    static var libraryFiles : NSArray = []
  }
  
  class func findLocalBooks() {
    var path : String = DataManager.loadOrCreatePath() as String
    var files : NSArray = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path, error: nil)!
    var array : NSMutableArray = NSMutableArray()
    for file in files {
      var handle : String = file.lastPathComponent
      array.addObject(handle)
    }
    println(files)
    self.container.libraryFiles = NSArray(array: array)
  }
  
  class func getBookFromFile(handle:String)->NSDictionary {
    var plistName = handle
    var folder = DataManager.getDownloadPath()
    var path = folder.stringByAppendingPathComponent(plistName)
    var dict : NSDictionary = NSDictionary(contentsOfFile: path)!
    return dict
    
  }
  
  class func htmlForBookHandle(handle:String) -> String {
    var plistName = handle
    var dictionary : NSDictionary = getBookFromFile(plistName) as NSDictionary
    var data : String = dictionary.objectForKey("bookData") as! String
    return data
  }
  
  class func titleForBookHandle(handle:String) -> String {
    var plistName = handle
    var dictionary : NSDictionary = getBookFromFile(plistName) as NSDictionary
    var data : String = dictionary.objectForKey("bookTitle") as! String
    return data
  }

  class func authorForBookHandle(handle:String) -> String {
    var plistName = handle
    var dictionary : NSDictionary = getBookFromFile(plistName) as NSDictionary
    var data : String = dictionary.objectForKey("bookAuthor") as! String
    return data
  }

  class func progressForBookHandle(handle:String) -> String {
    var plistName = handle
    var dictionary : NSDictionary = getBookFromFile(plistName) as NSDictionary
    var data : String = dictionary.objectForKey("bookProgress") as! String
    return data
  }

  class func saveProgress(handle:String, progress:Float) {
    var plistName = handle
    var dictionary : NSMutableDictionary = getBookFromFile(plistName) as! NSMutableDictionary
    var stringFromProgress : String = String(format: "%lf", progress)
    dictionary.setObject(stringFromProgress, forKey: "bookProgress")
    
    // create the path for the new dictionary
    var path : String = DataManager.loadOrCreatePath() as String
    var complete : String = path.stringByAppendingPathComponent(plistName)
    dictionary.writeToFile(complete, atomically: true)
  }
  
}
