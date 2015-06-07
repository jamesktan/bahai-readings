//
//  CloudKitService.swift
//  BahaiReadings
//
//  Created by James Tan on 6/3/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit
import CloudKit

class CloudKitService: NSObject {
  
  struct container {
    static var galleryList : NSArray = []
    static var galleryDownloaded : Bool = false
  }
  
  class func setupCloudService() {
    // Download everything we need from the Gallery and set to memory
    getBookGalleryByCategory("tablet")
    
  }
  
  class func getBooks() {
    CKRecord(recordType: "GalleryItem")
  }
  
  class func getCategoryList() -> NSArray {
    return ["tablet"]
  }
  
  class func getBookGalleryByCategory(category:String) { // tablet
    var publicDB : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var predicate : NSPredicate = NSPredicate(format: "bookCategory = %@", category)
    var query : CKQuery = CKQuery(recordType: "GalleryItem", predicate: predicate)
    publicDB.performQuery(query, inZoneWithID: nil, completionHandler: { results, error in
      if error != nil {
        println(error)
      }
      if error == nil && results != nil {
        NSLog("Category Found!")
        var resArray : NSArray = results as NSArray
        self.container.galleryList = resArray
        self.container.galleryDownloaded = true
        NSNotificationCenter.defaultCenter().postNotificationName("finishedDownloadingGallery", object: nil)        
      }
    })
  }
  
  class func getBookDetailsByHandle(handle:String) {
    var publicDB : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var predicate : NSPredicate = NSPredicate(format: "bookHandle = %@", handle)
    var query : CKQuery = CKQuery(recordType: "GalleryItem", predicate: predicate)
    publicDB.performQuery(query, inZoneWithID: nil, completionHandler: { results, error in
      if error != nil && results != nil {
        NSLog("Book Found!")
      }
    })

  }
  
  class func getBookGalleryByAuthor(author:String) {
    var publicDB : CKDatabase = CKContainer.defaultContainer().publicCloudDatabase
    var predicate : NSPredicate = NSPredicate(format: "bookAuthor = %@", author)
    var query : CKQuery = CKQuery(recordType: "GalleryItem", predicate: predicate)
    publicDB.performQuery(query, inZoneWithID: nil, completionHandler: { results, error in
      if error != nil && results != nil {
        NSLog("Author Found!")
      }
    })
  }
  
  class func getDownloadedBooks() {
    var privateDB : CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    var predicate : NSPredicate = NSPredicate(value: true)
    var query : CKQuery = CKQuery(recordType: "LibraryItem", predicate: predicate)
    privateDB.performQuery(query, inZoneWithID: nil, completionHandler: {
      results, error in
      if error != nil {
        NSLog("ERROR!")
      }
      if error == nil && results != nil {
        NSLog("Library Items Found!")
        for item in results {
          var itemRecord : CKRecord = item as! CKRecord
          var handle : String = itemRecord.objectForKey("bookHandle") as! String
          var progress : String = itemRecord.objectForKey("bookProgress") as! String
        }
      }
      
    })

  }
  
  class func userIsLoggedIn(handle:String, progress:Float) {
    CKContainer.defaultContainer().accountStatusWithCompletionHandler({
      status, error in
      if status == CKAccountStatus.NoAccount {
        NSLog("User NOT logged in")
      } else {
        NSLog("UserISLOGGEDIN!")
        self.saveBookProgress(handle, progress: progress)
      }
    })
  }
  
  
  class func saveBookProgress(handle:String, progress:Float) {
    
    var privateDatabase : CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    var predicate : NSPredicate = NSPredicate(format: "bookHandle = %@", handle)
    var query : CKQuery = CKQuery(recordType: "LibraryItem", predicate: predicate)
    
    privateDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { results, error in
      
      if error != nil {
        println(error)
      }
      
      if results != nil && error == nil {
        // If found, then update it.
        var resultsRec : NSArray = results
        var record : CKRecord = resultsRec.firstObject as! CKRecord
        record.setObject(NSNumber(float: progress), forKey: "bookProgress")
        privateDatabase.saveRecord(record, completionHandler: { (record, error) in
          NSLog("Saved to Library")
        })
        
      } else {
        // Save to the record if not found
        var record : CKRecord = CKRecord(recordType: "LibraryItem")
        record.setObject(NSString(UTF8String: handle), forKey: "bookHandle")
        record.setObject(NSNumber(float: progress), forKey: "bookProgress")
        privateDatabase.saveRecord(record, completionHandler: { (record, error) in
          NSLog("Saved to Library")
        })
      }

      
    })
    
    
  }
}
