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
  
  class func saveBookProgress(handle:String, progress:Float) {
    
    var privateDatabase : CKDatabase = CKContainer.defaultContainer().privateCloudDatabase
    var predicate : NSPredicate = NSPredicate(format: "bookHandle = %@", handle)
    var query : CKQuery = CKQuery(recordType: "LibraryItem", predicate: predicate)
    
    privateDatabase.performQuery(query, inZoneWithID: nil, completionHandler: { results, error in
      if error != nil {
        
      } else {
        
      }
      
    })
    
    
  }
}
