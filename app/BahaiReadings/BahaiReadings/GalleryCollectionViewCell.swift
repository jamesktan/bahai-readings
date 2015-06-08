//
//  GalleryCollectionViewCell.swift
//  BahaiReadings
//
//  Created by James Tan on 6/7/15.
//  Copyright (c) 2015 Karr Winn Labs. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var bookCover: UIImageView!
  @IBOutlet weak var bookTitle: UILabel!
  @IBOutlet weak var bookAuthor: UILabel!
  @IBOutlet weak var bookDescription: UILabel!
  @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
  
  var hiddenBookURL : String!
  var hiddenBookHandle : String!
  var hiddenCoverURL : String!
  var hiddenBookAuthor : String!
  
  @IBAction func downloadAndRead(sender: UIButton) {
    activityMonitor.startAnimating()
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
      DataManager.downloadFileToPlist(self.hiddenBookURL, title: self.bookTitle.text!, handle: self.hiddenBookHandle, author: self.hiddenBookAuthor, cover: self.hiddenCoverURL)
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.activityMonitor.stopAnimating()
      })

    })
  }
  
  
}
