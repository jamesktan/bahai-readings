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
  class func getBooks() {
    CKRecord(recordType: "GalleryItem")
  }
  
  class func getCategoryList() -> NSArray {
    return []
  }
  
  class func getBookGalleryByCategory(category:String) -> NSArray {
    return []
  }
  
  class func getBookGalleryByAuthor(author:String) -> NSArray {
    return []
  }
  
  class func userIsLoggedIn(handle:String, progress:Float) {
    CKContainer.defaultContainer().accountStatusWithCompletionHandler({
      status, error in
      if status == CKAccountStatus.NoAccount {
        
      } else {
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
        // If Query for Library Items Works
        
        if results != nil {
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
      } else {
        NSLog("No internet ACCESS!")
      }
      
    })
    
    
  }
}
