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
  
  
  
}
